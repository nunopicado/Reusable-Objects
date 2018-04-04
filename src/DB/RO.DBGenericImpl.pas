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
    FParams: TVariantArray;
  public
    constructor Create(Statement: string; Params: TVariantArray); overload;
    constructor Create(Statement: string); overload;
    class function New(Statement: string; Params: TVariantArray): ISQLStatement;
    destructor Destroy; override;
    function Statement: string;
    function Params: TVariantArray;
    function ParamCount: Integer;
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

function TSQLStatement.Statement: string;
begin
  Result := FStatement;
end;

function TSQLStatement.ParamCount: Integer;
begin
  Result := Length(FParams);
end;

function TSQLStatement.Params: TVariantArray;
begin
  Result := FParams;
end;

constructor TSQLStatement.Create(Statement: string; Params: TVariantArray);
begin
  FStatement := Statement;
  FParams    := Params;
end;

constructor TSQLStatement.Create(Statement: string);
begin
  Create(Statement, []);
end;

destructor TSQLStatement.Destroy;
begin
  SetLength(FParams, 0);
  inherited;
end;

class function TSQLStatement.New(Statement: string;
  Params: TVariantArray): ISQLStatement;
begin
  Result := Create(Statement, Params);
end;

end.
