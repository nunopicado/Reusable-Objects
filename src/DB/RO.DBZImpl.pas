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
    constructor Create(Server: IServer; Database: string; ClientCodePage, LibraryLocation: string);
    destructor Destroy; Override;
    class function New(Server: IServer; Database: string; ClientCodePage, LibraryLocation: string): IDatabase;
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function StartTransaction: IDatabase;
    function StopTransaction(const SaveChanges: Boolean = True): IDatabase;
    function IsConnected: Boolean;
    function Database: string;
    function NewQuery(const Statement: ISQLStatement): IDBQuery; overload;
    function NewQuery(const Statement: ISQLStatement; out Destination: IDBQuery): IDatabase; overload;
    function Run(const SQLStatement: ISQLStatement): IDatabase;
  end;

  TDatabase = TDBZDatabase;

  TZeosServer = class(TInterfacedObject, IServer)
  private
    FOrigin: IServer;
  public
    constructor Create(Origin: IServer);
    class function New(Origin: IServer): IServer;
    function Hostname: string;
    function Port: Word;
    function Username: string;
    function Password: string;
    function ServerType: TServerType;
    function TypeAsString: string;
  end;

implementation

type
  TDBZQuery = class(TInterfacedObject, IDBQuery)
  private
    FQuery: TZQuery;
    procedure AssignParams(SQLStatement: ISQLStatement);
  public
    constructor Create(const Connection: TZConnection; const SQLStatement: ISQLStatement);
    class function New(const Connection: TZConnection; const SQLStatement: ISQLStatement): IDBQuery;
    destructor Destroy; override;
    function Run: IDBQuery;
    function AsDataset: TDataset;
  end;

{ TDBZQuery }

function TDBZQuery.AsDataset: TDataset;
begin
  Result := FQuery;
end;

procedure TDBZQuery.AssignParams(SQLStatement: ISQLStatement);
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

class function TDBZQuery.New(const Connection: TZConnection; const SQLStatement: ISQLStatement): IDBQuery;
begin
  Result := Create(Connection, SQLStatement);
end;

function TDBZQuery.Run: IDBQuery;
begin
  Result := Self;
  if not FQuery.Connection.Connected
    then FQuery.Connection.Connect;
  FQuery.Open;
end;

{ TDatabase }

function TDBZDatabase.Connect: IDatabase;
begin
  Result := Self;
  FConnection.Connect;
end;

constructor TDBZDatabase.Create(Server: IServer; Database: string; ClientCodePage, LibraryLocation: string);
begin
  FConnection                        := TZConnection.Create(nil);
  FConnection.HostName               := Server.Hostname;
  FConnection.Port                   := Server.Port;
  FConnection.User                   := Server.Username;
  FConnection.Password               := Server.Password;
  FConnection.Database               := Database;
  FConnection.Catalog                := Database;
  FConnection.ClientCodePage         := ClientCodePage;
  FConnection.LibraryLocation        := LibraryLocation;
  FConnection.Protocol               := Server.TypeAsString;
  FConnection.TransactIsolationLevel := tiReadUncommitted;
end;

function TDBZDatabase.Database: string;
begin
  Result := FConnection.Database;
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

class function TDBZDatabase.New(Server: IServer; Database: string; ClientCodePage, LibraryLocation: string): IDatabase;
begin
  Result := Create(Server, Database, ClientCodePage, LibraryLocation);
end;

function TDBZDatabase.NewQuery(const Statement: ISQLStatement;
 out Destination: IDBQuery): IDatabase;
begin
  Result := Self;
  Destination := NewQuery(Statement);
end;

function TDBZDatabase.NewQuery(const Statement: ISQLStatement): IDBQuery;
begin
  Result := TDBZQuery.Create(FConnection, Statement);
end;

function TDBZDatabase.Run(const SQLStatement: ISQLStatement): IDatabase;
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

constructor TZeosServer.Create(Origin: IServer);
begin
  FOrigin := Origin;
end;

function TZeosServer.Hostname: string;
begin
  Result := FOrigin.Hostname;
end;

class function TZeosServer.New(Origin: IServer): IServer;
begin
  Result := Create(Origin);
end;

function TZeosServer.Password: string;
begin
  Result := FOrigin.Password;
end;

function TZeosServer.Port: Word;
begin
  Result := FOrigin.Port;
end;

function TZeosServer.ServerType: TServerType;
begin
  Result := FOrigin.ServerType;
end;

function TZeosServer.TypeAsString: string;
begin
  case FOrigin.ServerType of
    stMySQL      : Result := 'mysql-5';
    stMSSQL      : Result := 'mssql';
    stSQLite     : Result := 'sqlite-3';
    stPostgreSQL : Result := 'postgresql-9';
  else raise Exception.Create('Unknown Server Type');
  end;
end;

function TZeosServer.Username: string;
begin
  Result := FOrigin.Username;
end;

end.
