(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISNTPTime                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TSNTPTime, implements ISNTPTime                          **)
(******************************************************************************)
(** Dependencies  : RTL, Indy                                                **)
(******************************************************************************)
(** Description   : Retrieves a date and time from a NTP Server              **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**                 terms                                                    **)
(******************************************************************************)

unit RO.TSNTPTime;

interface

uses
    Generics.Collections
  , Classes
  , RO.IDate
  , RO.ISNTPTime
  , RO.IValue
  ;

type
  TSNTPTime = class(TInterfacedObject, ISNTPTime)
  private
    FServer : string;
  public
    constructor Create(Server: string);
    class function New(Server: string): ISNTPTime; overload;
    class function New(Server: IString): ISNTPTime; overload;
    function Now: TDateTime;
  end;

  TSNTPTimePool = class(TInterfacedObject, ISNTPTime)
  private
    FServerList : TList<string>;
    FIfFail     : TSPBehavior;
  public
    constructor Create(ServerList: array of string; IfFail: TSPBehavior);
    destructor Destroy; override;
    class function New(ServerList: array of string; IfFail: TSPBehavior): ISNTPTime; overload;
    class function New(ServerList: TStrings; IfFail: TSPBehavior): ISNTPTime; overload;
    function Now: TDateTime;
  end;

implementation

uses
    idSNTP
  , SysUtils
  , RO.TDate
  ;

{ TNTPTime }

constructor TSNTPTime.Create(Server: string);
begin
  FServer := Server;
end;

class function TSNTPTime.New(Server: string): ISNTPTime;
begin
  Result := Create(Server);
end;

class function TSNTPTime.New(Server: IString): ISNTPTime;
begin
  Result := New(Server.Value);
end;

function TSNTPTime.Now: TDateTime;
var
  NTP : TIdSNTP;
begin
  NTP := TIdSNTP.Create(nil);
  try
    NTP.ReceiveTimeout := 3000;
    NTP.Host           := FServer;
    Result             := NTP.DateTime;
  finally
    NTP.Free;
  end;
end;

{ TSNTPTimePool }

constructor TSNTPTimePool.Create(ServerList: array of string; IfFail: TSPBehavior);
begin
  FServerList := TList<string>.Create;
  FServerList.AddRange(ServerList);
  FIfFail     := IfFail;
end;

destructor TSNTPTimePool.Destroy;
begin
  FServerList.Free;
  inherited;
end;

class function TSNTPTimePool.New(ServerList: array of string; IfFail: TSPBehavior): ISNTPTime;
begin
  Result := Create(ServerList, IfFail);
end;

class function TSNTPTimePool.New(ServerList: TStrings;
  IfFail: TSPBehavior): ISNTPTime;
var
  List: array of string;
  i: Integer;
begin
  SetLength(List, ServerList.Count);
  for i := 0 to Pred(ServerList.Count) do
    List[i] := ServerList[i];
  Result := New(List, IfFail);
end;

function TSNTPTimePool.Now: TDateTime;
  function ValidDate(aDate: TDateTime): Boolean; inline;
  begin
    Result := FormatDateTime('yyyy', aDate) <> '1899';
  end;
var
  i: Integer;
begin
  i := 0;
  repeat
    Result := TSNTPTime.New(FServerList[i]).Now;
    Inc(i);
  until (i > FServerList.Count) or ValidDate(Result);
  if not ValidDate(Result)
    then case FIfFail of
           spReturnCurrentDate : Result := SysUtils.Now;
           spThrowException    : raise Exception.Create('Could not retrieve current date from any server in the list.');
         end;
end;

end.
