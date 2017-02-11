(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISNTPTime                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ISNTPTime                                                **)
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

unit Obj.SSI.ISNTPTime;

interface

uses
    Generics.Collections
  ;

type
    ISNTPTime = Interface ['{BFE1C861-89E5-4F8C-B0B1-3CEA18845737}']
      function Now: TDateTime;
    End;

    TSNTPTime = Class(TInterfacedObject, ISNTPTime)
    private
      FServer : String;
      constructor Create(Server: String);
    public
      class function New(Server: String): ISNTPTime;
      function Now: TDateTime;
    End;

    TSPBehavior   = (spThrowException, spReturnCurrentDate);
    TSNTPTimePool = Class(TInterfacedObject, ISNTPTime)
    private
      FServerList : TList<String>;
      FIfFail     : TSPBehavior;
      constructor Create(ServerList: Array of String; IfFail: TSPBehavior);
      destructor Destroy; Override;
    public
      class function New(ServerList: Array of String; IfFail: TSPBehavior): ISNTPTime;
      function Now: TDateTime;
    End;

implementation

uses
    idSNTP
  , SysUtils
  ;

{ TNTPTime }

constructor TSNTPTime.Create(Server: String);
begin
     FServer := Server;
end;

class function TSNTPTime.New(Server: String): ISNTPTime;
begin
     Result := Create(Server);
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

constructor TSNTPTimePool.Create(ServerList: Array of String; IfFail: TSPBehavior);
begin
     FServerList := TList<String>.Create;
     FServerList.AddRange(ServerList);
     FIfFail     := IfFail;
end;

destructor TSNTPTimePool.Destroy;
begin
     FServerList.Free;
     inherited;
end;

class function TSNTPTimePool.New(ServerList: Array of String; IfFail: TSPBehavior): ISNTPTime;
begin
     Result := Create(ServerList, IfFail);
end;

function TSNTPTimePool.Now: TDateTime;
  function ValidDate(aDate: TDateTime): Boolean; Inline;
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
                  spThrowException    : Raise Exception.Create('Could not retrieve current date from any server in the list.');
             end;
end;

end.
