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
  , Classes
  , MemData
  , DBAccess
  , SysUtils
  ;

resourcestring
  cUnknownServerType = 'Unknown Server Type';

type
  TROUniDatabase = class(TInterfacedObject, IDatabase)
  strict private
    FServerInfo       : IServerInfo;
    FConnection       : TUniConnection;
    FProvider         : TUniProvider;
    FReconnectAction  : TProc;
    FDisconnectAction : TProc;
    procedure DoExecute(const SQLStatement: ISQLStatement);
    procedure ConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure AfterConnect(Sender: TObject);
    procedure AfterDisconnect(Sender: TObject);
  public
    constructor Create(const ServerInfo: IServerInfo);
    destructor Destroy; override;
    class function New(const ServerInfo: IServerInfo): IDatabase;
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function IsConnected: Boolean;
    function OnReconnect(Action: TProc): IDatabase;
    function OnDisconnect(Action: TProc): IDatabase;
    function StartTransaction: IDatabase;
    function StopTransaction(const SaveChanges: Boolean = True): IDatabase;
    function Query(const Statement: ISQLStatement): IQuery;
    function Execute(const SQLStatement: ISQLStatement): IDatabase;
    function ServerInfo: IServerInfo;
  end;

  TDatabase = TROUniDatabase;

implementation

uses
    MySQLUniProvider
  , PostgreSQLUniProvider
  , SQLiteUniProvider
  , SQLServerUniProvider
  , RO.IValue
  , RO.TValue
  , RO.TIf
  , RO.TEnum
  , RO.DBGenericImpl
  , DB
  ;

type
  TROUniQuery = class(TInterfacedObject, IQuery)
  private
    FConnection: TUniConnection;
    FQuery: TUniQuery;
    procedure AssignParams(SQLStatement: ISQLStatement);
    function AddField(const List, NewField: string): string;
    function ForEach(const RowAction: TProc<TDataset>): IQuery;
  public
    constructor Create(const Connection: TUniConnection; const SQLStatement: ISQLStatement);
    class function New(const Connection: TUniConnection; const SQLStatement: ISQLStatement): IQuery;
    destructor Destroy; override;
    function Open: IQuery;
    function Close: IQuery;
    function Run: IQuery;
    function ReadOnly(const Value: Boolean): IQuery;
    function SetMasterSource(const MasterSource: TDataSource): IQuery;
    function AddMasterDetailLink(const Master, Detail: string; const Index: string = ''): IQuery;
    function AsDataset: TDataset;
    function AsJSON(const ForceArray: Boolean = true): string;
    function UpdateSQL(const Statement: ISQLStatement): IQuery;
    function DeleteSQL(const Statement: ISQLStatement): IQuery;
    function InsertSQL(const Statement: ISQLStatement): IQuery;
    function RefreshSQL(const Statement: ISQLStatement): IQuery;
    function LockSQL(const Statement: ISQLStatement): IQuery;
  end;

{ TROUniQuery }
{$REGION TROUniQuery}
function TROUniQuery.AddField(const List, NewField: string): string;
begin
  Result := List;
  if not Result.IsEmpty
    then Result := Result + ';';
  Result := Result + NewField;
end;

function TROUniQuery.AddMasterDetailLink(const Master, Detail: string; const Index: string = ''): IQuery;
begin
  Result := Self;
  FQuery.MasterFields := AddField(FQuery.MasterFields, Master);
  FQuery.DetailFields := AddField(FQuery.DetailFields, Detail);
  if not Index.IsEmpty
    then FQuery.IndexFieldNames := Index;
end;

function TROUniQuery.AsDataset: TDataset;
begin
  Result := FQuery;
end;

function TROUniQuery.AsJSON(const ForceArray: Boolean = true): string;
begin
  Result := TDatasetAsJSON
    .New(AsDataset, ForceArray)
      .Refresh
        .Value
end;

procedure TROUniQuery.AssignParams(SQLStatement: ISQLStatement);
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

function TROUniQuery.Close: IQuery;
begin
  Result := Self;
  FQuery.Close;
end;

constructor TROUniQuery.Create(const Connection: TUniConnection; const SQLStatement: ISQLStatement);
begin
  FConnection                   := Connection;
  FQuery                        := Uni.TUniQuery.Create(nil);
  FQuery.Connection             := Connection;
  FQuery.Options.RequiredFields := False;
  FQuery.SQL.Text               := SQLStatement.Statement;
  AssignParams(SQLStatement);
end;

function TROUniQuery.DeleteSQL(const Statement: ISQLStatement): IQuery;
begin
  Result                := Self;
  FQuery.SQLDelete.Text := Statement.Statement;
end;

destructor TROUniQuery.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TROUniQuery.ForEach(const RowAction: TProc<TDataset>): IQuery;
var
  i: Integer;
begin
  Result := Self;
  for i := 1 to FQuery.RecordCount do
    begin
      FQuery.RecNo := i;
      RowAction(FQuery);
    end;
end;

function TROUniQuery.InsertSQL(const Statement: ISQLStatement): IQuery;
begin
  Result                := Self;
  FQuery.SQLInsert.Text := Statement.Statement;
end;

function TROUniQuery.LockSQL(const Statement: ISQLStatement): IQuery;
begin
  Result              := Self;
  FQuery.SQLLock.Text := Statement.Statement;
end;

class function TROUniQuery.New(const Connection: TUniConnection; const SQLStatement: ISQLStatement): IQuery;
begin
  Result := Create(Connection, SQLStatement);
end;

function TROUniQuery.Open: IQuery;
begin
  Result := Self;
  if not Assigned(FQuery.Connection)
    then FQuery.Connection := FConnection;
  FQuery.Open;
end;

function TROUniQuery.ReadOnly(const Value: Boolean): IQuery;
begin
  Result          := Self;
  FQuery.ReadOnly := Value;
end;

function TROUniQuery.RefreshSQL(const Statement: ISQLStatement): IQuery;
begin
  Result                  := Self;
  FQuery.SQLRefresh.Text  := Statement.Statement;
end;

function TROUniQuery.Run: IQuery;
begin
  Result := Self;
  if not FQuery.Connection.Connected
    then FQuery.Connection.Connect;
  FQuery.Open;
end;

function TROUniQuery.SetMasterSource(const MasterSource: TDataSource): IQuery;
begin
  Result := Self;
  FQuery.MasterSource := MasterSource;
end;
function TROUniQuery.UpdateSQL(const Statement: ISQLStatement): IQuery;
begin
  Result                := Self;
  FQuery.SQLUpdate.Text := Statement.Statement;
end;

{$ENDREGION}

{ TROUniDatabase }
{$REGION TROUniDatabase}
procedure TROUniDatabase.ConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  RetryMode := TRetryMode.rmReconnectExecute;
end;

procedure TROUniDatabase.AfterConnect(Sender: TObject);
begin
  if Assigned(FReconnectAction)
    then FReconnectAction();
end;

procedure TROUniDatabase.AfterDisconnect(Sender: TObject);
begin
  if Assigned(FDisconnectAction)
    then FDisconnectAction();
end;

function TROUniDatabase.Connect: IDatabase;
begin
  Result := Self;
  if not IsConnected
    then FConnection.Connect;
end;

constructor TROUniDatabase.Create(const ServerInfo: IServerInfo);
begin
  FServerInfo                   := ServerInfo;
  FConnection                   := TUniConnection.Create(nil);
  FConnection.Server            := ServerInfo.Hostname;
  FConnection.Port              := ServerInfo.Port;
  FConnection.Username          := ServerInfo.Username;
  FConnection.Password          := ServerInfo.Password;
  FConnection.Database          := ServerInfo.Database;
  FConnection.ProviderName      := ServerInfo.TypeAsString;
  FConnection.OnConnectionLost  := ConnectionLost;
  case ServerInfo.ServerType of
    stMySQL      : FProvider  := TMySQLUniProvider.Create(nil);
    stMSSQL      : FProvider  := TSQLServerUniProvider.Create(nil);
    stSQLite     : FProvider  := TSQLiteUniProvider.Create(nil);
    stPostgreSQL : FProvider  := TPostgreSQLUniProvider.Create(nil);
  else raise Exception.Create(cUnknownServerType);
  end;
end;

function TROUniDatabase.ServerInfo: IServerInfo;
begin
  Result := FServerInfo;
end;

destructor TROUniDatabase.Destroy;
begin
  FProvider.Free;
  FConnection.Free;
  inherited;
end;

function TROUniDatabase.Disconnect: IDatabase;
begin
  Result := Self;
  if IsConnected
    then FConnection.Disconnect;
end;

procedure TROUniDatabase.DoExecute(const SQLStatement: ISQLStatement);
begin
  FConnection.ExecSQLEx(SQLStatement.Statement, SQLStatement.Params);
end;

function TROUniDatabase.IsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

class function TROUniDatabase.New(const ServerInfo: IServerInfo): IDatabase;
begin
  Result := Create(ServerInfo);
end;

function TROUniDatabase.OnDisconnect(Action: TProc): IDatabase;
begin
  Result := Self;
  FDisconnectAction := Action;
end;

function TROUniDatabase.OnReconnect(Action: TProc): IDatabase;
begin
  Result := Self;
  FReconnectAction := Action;
end;

function TROUniDatabase.Query(const Statement: ISQLStatement): IQuery;
begin
  Result := TROUniQuery.Create(FConnection, Statement);
end;

function TROUniDatabase.Execute(const SQLStatement: ISQLStatement): IDatabase;
begin
  Result := Self;
  Self.Connect;
  DoExecute(SQLStatement);
end;

function TROUniDatabase.StartTransaction: IDatabase;
begin
  FConnection.StartTransaction;
end;

function TROUniDatabase.StopTransaction(const SaveChanges: Boolean = True): IDatabase;
begin
  if SaveChanges
    then FConnection.Commit
    else FConnection.Rollback;
end;
{$ENDREGION}

end.
