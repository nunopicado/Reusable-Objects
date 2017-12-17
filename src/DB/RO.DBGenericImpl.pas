(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TServer                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TServer                                                  **)
(**                 TSQLStatement                                            **)
(**                 TSQLParam                                                **)
(**                 TSQLParams                                               **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : An implementation of IDatabase related interfaces that   **)
(**                 do not require external frameworks                       **)
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

unit RO.DBGenericImpl;

interface

uses
    RO.DBConnectionIntf
  , System.Generics.Collections
  ;

type
  TServer = class(TInterfacedObject, IServer)
  private
    FHostname: string;
    FPort: Word;
    FUsername: string;
    FPassword: string;
    FServerType: TServerType;
  public
    constructor Create(const HostName: string; const Port: Word; const Username, Password: string; ServerType: TServerType);
    class function New(const HostName: string; const Port: Word; const Username, Password: string; ServerType: TServerType): IServer;
    function Hostname: string;
    function Port: Word;
    function Username: string;
    function Password: string;
    function ServerType: TServerType;
    function TypeAsString: string;
  end;

  TSQLStatement = class(TInterfacedObject, ISQLStatement)
  strict private
    FStatement: string;
    FParamList: ISQLParams;
  public
    constructor Create(Statement: string; Params: ISQLParams);
    class function New(Statement: string; Params: ISQLParams): ISQLStatement; overload;
    class function New(Statement: string): ISQLStatement; overload;
    function ParamList: ISQLParams;
    function AsString: string;
  end;

  TSQLParam = class(TInterfacedObject, ISQLParam)
  strict private
    FName: string;
    FValue: Variant;
  public
    constructor Create(Name: string; Value: Variant);
    class function New(Name: string; Value: Variant): ISQLParam;
    function Name: string;
    function Value: Variant;
  end;

  TSQLParams = class(TInterfacedObject, ISQLParams)
  strict private
    FList: TList<ISQLParam>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: ISQLParams; overload;
    class function New(Param: ISQLParam): ISQLParams; overload;
    function Add(Param: ISQLParam): ISQLParams;
    function Param(Idx: Integer): ISQLParam;
    function AsVariantArray: TVariantArray;
    function Count: Integer;
  end;

implementation

uses
    SysUtils
  ;

{ TServer }

constructor TServer.Create(const HostName: string; const Port: Word; const Username, Password: string;
  ServerType: TServerType);
begin
  FHostname   := HostName;
  FPort       := Port;
  FUsername   := Username;
  FPassword   := Password;
  FServerType := ServerType;
end;

function TServer.Hostname: string;
begin
  Result := FHostname;
end;

class function TServer.New(const HostName: string; const Port: Word; const Username, Password: string;
  ServerType: TServerType): IServer;
begin
  Result := Create(HostName, Port, Username, Password, ServerType);
end;

function TServer.Password: string;
begin
  Result := FPassword;
end;

function TServer.Port: Word;
begin
  Result := FPort;
end;

function TServer.ServerType: TServerType;
begin
  Result := FServerType;
end;

function TServer.TypeAsString: string;
begin
  case FServerType of
    stMySQL      : Result := 'MySQL';
    stMSSQL      : Result := 'SQL Server';
    stSQLite     : Result := 'SQLite';
    stPostgreSQL : Result := 'PostgreSQL';
  else raise Exception.Create('Unknown Server Type');
  end;
end;

function TServer.Username: string;
begin
  Result := FUsername;
end;

{ TSQLStatement }

function TSQLStatement.AsString: string;
begin
  Result := FStatement;
end;

constructor TSQLStatement.Create(Statement: string; Params: ISQLParams);
begin
  FStatement := Statement;
  FParamList := Params;
end;

class function TSQLStatement.New(Statement: string): ISQLStatement;
begin
  Result := New(
    Statement,
    TSQLParams.New
  );
end;

class function TSQLStatement.New(Statement: string; Params: ISQLParams): ISQLStatement;
begin
  Result := Create(Statement, Params);
end;

function TSQLStatement.ParamList: ISQLParams;
begin
  Result := FParamList;
end;

{ TSQLParam }

constructor TSQLParam.Create(Name: string; Value: Variant);
begin
  FName  := Name;
  FValue := Value;
end;

function TSQLParam.Name: string;
begin
  Result := FName;
end;

class function TSQLParam.New(Name: string; Value: Variant): ISQLParam;
begin
  Result := Create(Name, Value);
end;

function TSQLParam.Value: Variant;
begin
  Result := FValue;
end;

{ TSQLParams }

function TSQLParams.Add(Param: ISQLParam): ISQLParams;
begin
  Result := Self;
  FList.Add(Param);
end;

function TSQLParams.AsVariantArray: TVariantArray;
var
  i: Integer;
begin
  SetLength(Result, FList.Count * 2);
  if FList.Count > 0 then begin
    for i := 0 to FList.Count-1 do begin
      Result[(i+1)*2-2] := FList[i].Name;
      Result[(i+1)*2-1] := FList[i].Value;
    end;
  end;
end;

function TSQLParams.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TSQLParams.Create;
begin
  FList := TList<ISQLParam>.Create;
end;

destructor TSQLParams.Destroy;
begin
  FList.Free;
  inherited;
end;

class function TSQLParams.New: ISQLParams;
begin
  Result := Create;
end;

class function TSQLParams.New(Param: ISQLParam): ISQLParams;
begin
  Result := Create.Add(Param);
end;

function TSQLParams.Param(Idx: Integer): ISQLParam;
begin
  if FList.Count > 0 then begin
    Result := FList[Idx];
  end;
end;

end.
