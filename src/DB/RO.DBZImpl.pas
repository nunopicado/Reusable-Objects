(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TDBZDatabase                                             **)
(** Framework     : ZeosLIB                                                  **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TDBZDatabase                                             **)
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
(** Description   : An implementation of IDatabase based on ZeosLIB          **)
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

unit RO.DBZImpl;

interface

uses
    RO.DBConnectionIntf
  , ZConnection
  , ZDataset
  , ZDbcIntfs
  , DB
  , SysUtils
  ;

type
  TDBZDatabase = class(TInterfacedObject, IDatabase)
  strict private
    FConnection: TZConnection;
  public
    constructor Create(const ServerInfo: IServerInfo; const ClientCodePage, LibraryLocation: string);
    destructor Destroy; Override;
    class function New(const ServerInfo: IServerInfo; const ClientCodePage, LibraryLocation: string): IDatabase;
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function IsConnected: Boolean;
    function StartTransaction: IDatabase;
    function StopTransaction(const SaveChanges: Boolean = True): IDatabase;
    function Query(const Statement: ISQLStatement): IQuery;
    function Execute(const SQLStatement: ISQLStatement): IDatabase;
  end;

  TDatabase = TDBZDatabase;

  TZeosServerInfo = class(TInterfacedObject, IServerInfo)
  private
    FOrigin: IServerInfo;
  public
    constructor Create(const Origin: IServerInfo);
    class function New(const Origin: IServerInfo): IServerInfo;
    function Hostname: string;
    function Port: Word;
    function Username: string;
    function Password: string;
    function Database: string;
    function BinPath: string;
    function UpdatePath: string;
    function ServerType: TServerType;
    function TypeAsString: string;
  end;

implementation

type
  TDBZQuery = class(TInterfacedObject, IQuery)
  private
    FQuery: TZQuery;
    procedure AssignParams(const SQLStatement: ISQLStatement);
    function AddField(const List, NewField: string): string;
  public
    constructor Create(const Connection: TZConnection; const SQLStatement: ISQLStatement);
    class function New(const Connection: TZConnection; const SQLStatement: ISQLStatement): IQuery;
    destructor Destroy; override;
    function Run: IQuery;
    function SetMasterSource(const MasterSource: TDataSource): IQuery;
    function AddMasterDetailLink(const Master, Detail: string): IQuery;
    function ForEach(const RowAction: TProc<TDataset>): IQuery;
    function AsDataset: TDataset;
  end;

{ TDBZQuery }

function TDBZQuery.AddField(const List, NewField: string): string;
begin
  Result := List;
  if not Result.IsEmpty
    then Result := Result + ';';
  Result := Result + NewField;
end;

function TDBZQuery.AddMasterDetailLink(const Master, Detail: string): IQuery;
begin
  Result := Self;
  raise Exception.Create('Not yet implemented');
//  FQuery.MasterFields := AddField(FQuery.MasterFields, Master);
//  FQuery.DetailFields := AddField(FQuery.DetailFields, Detail);
end;

function TDBZQuery.AsDataset: TDataset;
begin
  Result := FQuery;
end;

procedure TDBZQuery.AssignParams(const SQLStatement: ISQLStatement);
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

constructor TDBZQuery.Create(const Connection: TZConnection; const SQLStatement: ISQLStatement);
begin
  FQuery              := TZQuery.Create(nil);
  FQuery.Connection   := Connection;
  FQuery.SQL.Text     := SQLStatement.Statement;
  AssignParams(SQLStatement);
end;

destructor TDBZQuery.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TDBZQuery.ForEach(const RowAction: TProc<TDataset>): IQuery;
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

class function TDBZQuery.New(const Connection: TZConnection; const SQLStatement: ISQLStatement): IQuery;
begin
  Result := Create(Connection, SQLStatement);
end;

function TDBZQuery.Run: IQuery;
begin
  Result := Self;
  if not FQuery.Connection.Connected
    then FQuery.Connection.Connect;
  FQuery.Open;
end;

function TDBZQuery.SetMasterSource(const MasterSource: TDataSource): IQuery;
begin
  Result := Self;
  FQuery.MasterSource := MasterSource;
end;

{ TDatabase }

function TDBZDatabase.Connect: IDatabase;
begin
  Result := Self;
  FConnection.Connect;
end;

constructor TDBZDatabase.Create(const ServerInfo: IServerInfo; const ClientCodePage, LibraryLocation: string);
begin
  FConnection                        := TZConnection.Create(nil);
  FConnection.HostName               := ServerInfo.Hostname;
  FConnection.Port                   := ServerInfo.Port;
  FConnection.User                   := ServerInfo.Username;
  FConnection.Password               := ServerInfo.Password;
  FConnection.Database               := ServerInfo.Database;
  FConnection.Catalog                := ServerInfo.Database;
  FConnection.ClientCodePage         := ClientCodePage;
  FConnection.LibraryLocation        := LibraryLocation;
  FConnection.Protocol               := ServerInfo.TypeAsString;
  FConnection.TransactIsolationLevel := tiReadUncommitted;
end;

destructor TDBZDatabase.Destroy;
begin
  FConnection.Free;
  inherited;
end;

function TDBZDatabase.Disconnect: IDatabase;
begin
  Result := Self;
  FConnection.Disconnect;
end;

function TDBZDatabase.IsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

class function TDBZDatabase.New(const ServerInfo: IServerInfo; const ClientCodePage, LibraryLocation: string): IDatabase;
begin
  Result := Create(ServerInfo, ClientCodePage, LibraryLocation);
end;

function TDBZDatabase.Query(const Statement: ISQLStatement): IQuery;
begin
  Result := TDBZQuery.Create(FConnection, Statement);
end;

function TDBZDatabase.Execute(const SQLStatement: ISQLStatement): IDatabase;
begin
  Result := Self;
  FConnection.ExecuteDirect(SQLStatement.Statement);
end;

function TDBZDatabase.StartTransaction: IDatabase;
begin
  FConnection.StartTransaction;
end;

function TDBZDatabase.StopTransaction(const SaveChanges: Boolean = True): IDatabase;
begin
  if SaveChanges then begin
    FConnection.Commit;
  end
  else begin
    FConnection.Rollback;
  end;
end;

{ TZeosServer }

function TZeosServerInfo.BinPath: string;
begin
  Result := FOrigin.BinPath;
end;

constructor TZeosServerInfo.Create(const Origin: IServerInfo);
begin
  FOrigin := Origin;
end;

function TZeosServerInfo.Database: string;
begin
  Result := FOrigin.Database;
end;

function TZeosServerInfo.Hostname: string;
begin
  Result := FOrigin.Hostname;
end;

class function TZeosServerInfo.New(const Origin: IServerInfo): IServerInfo;
begin
  Result := Create(Origin);
end;

function TZeosServerInfo.Password: string;
begin
  Result := FOrigin.Password;
end;

function TZeosServerInfo.Port: Word;
begin
  Result := FOrigin.Port;
end;

function TZeosServerInfo.ServerType: TServerType;
begin
  Result := FOrigin.ServerType;
end;

function TZeosServerInfo.TypeAsString: string;
begin
  case FOrigin.ServerType of
    stMySQL      : Result := 'mysql-5';
    stMSSQL      : Result := 'mssql';
    stSQLite     : Result := 'sqlite-3';
    stPostgreSQL : Result := 'postgresql-9';
  else raise Exception.Create('Unknown Server Type');
  end;
end;

function TZeosServerInfo.UpdatePath: string;
begin
  Result := FOrigin.UpdatePath;
end;

function TZeosServerInfo.Username: string;
begin
  Result := FOrigin.Username;
end;

end.
