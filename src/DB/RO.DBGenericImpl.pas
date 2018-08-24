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

resourcestring
  cIncorrectParameterList = 'Incorrect parameter list';

type
  TServerInfo = class(TInterfacedObject, IServerInfo)
  private
    FHostname   : string;
    FPort       : Word;
    FUsername   : string;
    FPassword   : string;
    FServerType : TServerType;
    FDatabase   : string;
    FBinPath    : string;
    FUpdatePath : string;
  public
    constructor Create(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType; const Database, BinPath, UpdatePath: string);
    class function New(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType; const Database, BinPath, UpdatePath: string): IServerInfo;
    function HostName: string;
    function Port: Word;
    function Username: string;
    function Password: string;
    function Database: string;
    function BinPath: string;
    function UpdatePath: string;
    function ServerType: TServerType;
    function TypeAsString: string;
  end;

  TSQLStatement = class(TInterfacedObject, ISQLStatement)
  strict private
    FStatement: string;
    FParams: TVariantArray;
  public
    constructor Create(const Statement: string; const Params: TVariantArray); overload;
    constructor Create(const Statement: string); overload;
    class function New(const Statement: string; const Params: TVariantArray): ISQLStatement; overload;
    class function New(const Statement: string): ISQLStatement; overload;
    destructor Destroy; override;
    function Statement: string;
    function Params: TVariantArray;
    function ParamCount: Integer;
  end;

implementation

uses
    SysUtils
  ;

{ TServerInfo }
{$REGION TServerInfo}
function TServerInfo.BinPath: string;
begin
  Result := FBinPath;
end;

constructor TServerInfo.Create(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType;
  const Database, BinPath, UpdatePath: string);
begin
  FHostname   := HostName;
  FPort       := Port;
  FUsername   := Username;
  FPassword   := Password;
  FServerType := ServerType;
  FDatabase   := Database;
  FBinPath    := BinPath;
  FUpdatePath := UpdatePath;
end;

function TServerInfo.Database: string;
begin
  Result := FDatabase;
end;

function TServerInfo.Hostname: string;
begin
  Result := FHostname;
end;

class function TServerInfo.New(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType;
  const Database, BinPath, UpdatePath: string): IServerInfo;
begin
  Result := Create(HostName, Port, Username, Password, ServerType, Database, BinPath, UpdatePath);
end;

function TServerInfo.Password: string;
begin
  Result := FPassword;
end;

function TServerInfo.Port: Word;
begin
  Result := FPort;
end;

function TServerInfo.ServerType: TServerType;
begin
  Result := FServerType;
end;

function TServerInfo.TypeAsString: string;
begin
  case FServerType of
    stMySQL      : Result := 'MySQL';
    stMSSQL      : Result := 'SQL Server';
    stSQLite     : Result := 'SQLite';
    stPostgreSQL : Result := 'PostgreSQL';
  else raise Exception.Create('Unknown Server Type');
  end;
end;

function TServerInfo.UpdatePath: string;
begin
  Result := FUpdatePath;
end;

function TServerInfo.Username: string;
begin
  Result := FUsername;
end;
{$ENDREGION}

{ TSQLStatement }
{$REGION TSQLStatement}
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

constructor TSQLStatement.Create(const Statement: string; const Params: TVariantArray);
begin
  if Length(Params) mod 2 <> 0
    then raise Exception.Create(cIncorrectParameterList);
  FStatement := Statement;
  FParams    := Params;
end;

constructor TSQLStatement.Create(const Statement: string);
begin
  Create(Statement, []);
end;

destructor TSQLStatement.Destroy;
begin
  SetLength(FParams, 0);
  inherited;
end;

class function TSQLStatement.New(const Statement: string): ISQLStatement;
begin
  Result := New(Statement, []);
end;

class function TSQLStatement.New(const Statement: string; const Params: TVariantArray): ISQLStatement;
begin
  Result := Create(Statement, Params);
end;
{$ENDREGION}

end.
