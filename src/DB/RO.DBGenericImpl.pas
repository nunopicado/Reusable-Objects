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
    constructor Create(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType);
    class function New(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType): IServer;
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
    constructor Create(const Statement: string; const Params: ISQLParams);
    class function New(const Statement: string; const Params: ISQLParams): ISQLStatement; overload;
    class function New(const Statement: string): ISQLStatement; overload;
    function ParamList: ISQLParams;
    function AsString: string;
  end;

  TSQLParam = class(TInterfacedObject, ISQLParam)
  strict private
    FName: string;
    FValue: Variant;
  public
    constructor Create(const Name: string; const Value: Variant);
    class function New(const Name: string; const Value: Variant): ISQLParam;
    function Name: string;
    function Value: Variant;
  end;

  TSQLParams = class(TInterfacedObject, ISQLParams)
  strict private
    FList: TList<ISQLParam>;
  public
    constructor Create; overload;
    constructor Create(const Param: ISQLParam); overload;
    destructor Destroy; override;
    class function New: ISQLParams; overload;
    class function New(const Param: ISQLParam): ISQLParams; overload;
    function Add(const Param: ISQLParam): ISQLParams;
    function Param(const Idx: Integer): ISQLParam;
    function AsVariantArray: TVariantArray;
    function Count: Integer;
  end;

implementation

uses
    SysUtils
  ;

{ TServer }

constructor TServer.Create(const HostName: string; const Port: Word; const Username, Password: string;
  const ServerType: TServerType);
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
  const ServerType: TServerType): IServer;
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

constructor TSQLStatement.Create(const Statement: string; const Params: ISQLParams);
begin
  FStatement := Statement;
  FParamList := Params;
end;

class function TSQLStatement.New(const Statement: string): ISQLStatement;
begin
  Result := New(
    Statement,
    TSQLParams.New
  );
end;

class function TSQLStatement.New(const Statement: string; const Params: ISQLParams): ISQLStatement;
begin
  Result := Create(Statement, Params);
end;

function TSQLStatement.ParamList: ISQLParams;
begin
  Result := FParamList;
end;

{ TSQLParam }

constructor TSQLParam.Create(const Name: string; const Value: Variant);
begin
  FName  := Name;
  FValue := Value;
end;

function TSQLParam.Name: string;
begin
  Result := FName;
end;

class function TSQLParam.New(const Name: string; const Value: Variant): ISQLParam;
begin
  Result := Create(Name, Value);
end;

function TSQLParam.Value: Variant;
begin
  Result := FValue;
end;

{ TSQLParams }

function TSQLParams.Add(const Param: ISQLParam): ISQLParams;
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

constructor TSQLParams.Create(const Param: ISQLParam);
begin
  Create;
  Add(Param);
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

class function TSQLParams.New(const Param: ISQLParam): ISQLParams;
begin
  Result := Create(Param);
end;

function TSQLParams.Param(const Idx: Integer): ISQLParam;
begin
  if FList.Count > 0 then begin
    Result := FList[Idx];
  end;
end;

end.
