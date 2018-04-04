(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TDBUniDatabase                                           **)
(** Framework     : UniDAC                                                   **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TDBUniDatabase                                           **)
(**                 TDBUniQuery                                              **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : UniDAC, VCL                                              **)
(******************************************************************************)
(** Description   : An implementation of IDatabase based on UniDAC           **)
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

unit RO.DBUniImpl;

interface

uses
    RO.DBConnectionIntf
  , Uni
  , UniProvider
  , DB
  , SysUtils
  ;

type
  TDBUniDatabase = class(TInterfacedObject, IDatabase)
  strict private
    FConnection: TUniConnection;
    FProvider: TUniProvider;
  public
    constructor Create(const Server: IServer; const Database: string);
    destructor Destroy; override;
    class function New(const Server: IServer; const Database: string): IDatabase;
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function StartTransaction: IDatabase;
    function StopTransaction(const SaveChanges: Boolean = True): IDatabase;
    function IsConnected: Boolean;
    function Database: string;
    function NewQuery(const Statement: ISQLStatement): IDBQuery; overload;
    function NewQuery(const Statement: ISQLStatement; out Destination: IDBQuery): IDatabase; overload;
    function Run(const SQLStatement: ISQLStatement): IDatabase;
    function Connection: TUniConnection;
  end;

  TDatabase = TDBUniDatabase;

implementation

uses
    MySQLUniProvider
  , PostgreSQLUniProvider
  , SQLiteUniProvider
  , SQLServerUniProvider
  , RO.IValue
  , RO.TValue
  , RO.TIf
  ;

type
  TDBUniQuery = class(TInterfacedObject, IDBQuery)
  private
    FQuery: TUniQuery;
    procedure AssignParams(SQLStatement: ISQLStatement);
  public
    constructor Create(const Connection: TUniConnection; const SQLStatement: ISQLStatement);
    class function New(const Connection: TUniConnection; const SQLStatement: ISQLStatement): IDBQuery;
    destructor Destroy; override;
    function Run: IDBQuery;
    function AsDataset: TDataset;
  end;

{ TDBUniQuery }

function TDBUniQuery.AsDataset: TDataset;
begin
  Result := FQuery;
end;

procedure TDBUniQuery.AssignParams(SQLStatement: ISQLStatement);
var
  Idx: Integer;
begin
  Idx := 0;
  while Idx <= Pred(SQLStatement.ParamCount) - 1 do
    begin
      FQuery.ParamByName(SQLStatement.Params[Idx]).Value := SQLStatement.Params[Succ(Idx)];
      Inc(Idx, 2);
    end;
end;

constructor TDBUniQuery.Create(const Connection: TUniConnection; const SQLStatement: ISQLStatement);
begin
  FQuery              := Uni.TUniQuery.Create(nil);
  FQuery.Connection   := Connection;
  FQuery.SQL.Text     := SQLStatement.Statement;
  AssignParams(SQLStatement);
end;

destructor TDBUniQuery.Destroy;
begin
  FQuery.Free;
  inherited;
end;

class function TDBUniQuery.New(const Connection: TUniConnection; const SQLStatement: ISQLStatement): IDBQuery;
begin
  Result := Create(Connection, SQLStatement);
end;

function TDBUniQuery.Run: IDBQuery;
begin
  Result := Self;
  if not FQuery.Connection.Connected
    then FQuery.Connection.Connect;
  FQuery.Open;
end;

{ TDatabase }

function TDBUniDatabase.Connect: IDatabase;
begin
  Result := Self;
  FConnection.Connect;
end;

function TDBUniDatabase.Connection: TUniConnection;
begin
  Result := FConnection;
end;

constructor TDBUniDatabase.Create(const Server: IServer; const Database: string);
begin
  FConnection              := TUniConnection.Create(nil);
  FConnection.Server       := Server.Hostname;
  FConnection.Port         := Server.Port;
  FConnection.Username     := Server.Username;
  FConnection.Password     := Server.Password;
  FConnection.Database     := Database;
  FConnection.ProviderName := Server.TypeAsString;
  case Server.ServerType of
    stMySQL      : FProvider := TMySQLUniProvider.Create(nil);
    stMSSQL      : FProvider := TSQLServerUniProvider.Create(nil);
    stSQLite     : FProvider := TSQLiteUniProvider.Create(nil);
    stPostgreSQL : FProvider := TPostgreSQLUniProvider.Create(nil);
  else raise Exception.Create('Unknown Server Type');
  end;
end;

function TDBUniDatabase.Database: string;
begin
  Result := FConnection.Database;
end;

destructor TDBUniDatabase.Destroy;
begin
  FProvider.Free;
  FConnection.Free;
  inherited;
end;

function TDBUniDatabase.Disconnect: IDatabase;
begin
  Result := Self;
  FConnection.Disconnect;
end;

function TDBUniDatabase.IsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

class function TDBUniDatabase.New(const Server: IServer; const Database: string): IDatabase;
begin
  Result := Create(Server, Database);
end;

function TDBUniDatabase.NewQuery(const Statement: ISQLStatement;
 out Destination: IDBQuery): IDatabase;
begin
  Result := Self;
  Destination := NewQuery(Statement);
end;

function TDBUniDatabase.NewQuery(const Statement: ISQLStatement): IDBQuery;
begin
  Result := TDBUniQuery.Create(FConnection, Statement);
end;

function TDBUniDatabase.Run(const SQLStatement: ISQLStatement): IDatabase;
begin
  Result := Self;
  Self.Connect;
  FConnection.ExecSQLEx(SQLStatement.Statement, SQLStatement.Params);
end;

function TDBUniDatabase.StartTransaction: IDatabase;
begin
  FConnection.StartTransaction;
end;

function TDBUniDatabase.StopTransaction(const SaveChanges: Boolean = True): IDatabase;
begin
  if SaveChanges then begin
    FConnection.Commit;
  end
  else begin
    FConnection.Rollback;
  end;
end;

end.
