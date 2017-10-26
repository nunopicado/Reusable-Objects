(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TDBUniDatabase                                           **)
(** Framework     : UniDAC                                                   **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TDBUniDatabase, implements IDatabase                     **)
(**                 TDBUniQuery, implements IDBQuery                         **)
(******************************************************************************)
(** Dependencies  : RTL, UniDAC                                              **)
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

unit Obj.SSI.DBUniImpl;

interface

uses
    Obj.SSI.DBConnectionIntf
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
    constructor Create(Server: IServer; Database: string);
    destructor Destroy; override;
    class function New(Server: IServer; Database: string): IDatabase;
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function StartTransaction: IDatabase;
    function StopTransaction(SaveChanges: Boolean = True): IDatabase;
    function IsConnected: Boolean;
    function Database: string;
    function NewQuery(const Statement: ISQLStatement): IDBQuery; overload;
    function NewQuery(const Statement: ISQLStatement; out Destination: IDBQuery): IDatabase; overload;
    function Run(SQLStatement: ISQLStatement): IDatabase;
  end;

  TDatabase = TDBUniDatabase;

implementation

uses
    MySQLUniProvider
  , PostgreSQLUniProvider
  , SQLiteUniProvider
  , SQLServerUniProvider
  , Obj.SSI.IValue
  , Obj.SSI.TValue
  , Obj.SSI.TIf
  ;

type
  TDBUniQuery = class(TInterfacedObject, IDBQuery)
  private
    FQuery: IValue<TUniQuery>;
    procedure SetRecNo(Idx: Integer);
    function GetRecNo: Integer;
  public
    constructor Create(Connection: TUniConnection; Statement: ISQLStatement);
    destructor Destroy; override;
    class function New(Connection: TUniConnection; Statement: ISQLStatement): IDBQuery;
    function Publish(DataSource: TDataSource): IDBQuery;
    function RecordCount: Integer;
    function FieldByName(FieldName: string): TField;
    function ForEach(Action: TRowAction): IDBQuery;
    function Run: IDBQuery;
    function Insert: IDBQuery;
    function Edit: IDBQuery;
    function Append: IDBQuery;
    function Post: IDBQuery;
    function FieldValue(FieldName: string; Value: Variant): IDBQuery;
    property RecNo: Integer
      read GetRecNo
      write SetRecNo;
  end;

{ TDBUniQuery }

function TDBUniQuery.Post: IDBQuery;
begin
  Result := Self;
  FQuery.Value.Post;
end;

function TDBUniQuery.Publish(DataSource: TDataSource): IDBQuery;
begin
  Result := Self;
  DataSource.DataSet := FQuery.Value;
end;

function TDBUniQuery.Append: IDBQuery;
begin
  Result := Self;
  FQuery.Value.Append;
end;

constructor TDBUniQuery.Create(Connection: TUniConnection; Statement: ISQLStatement);
begin
  FQuery := TValue<TUniQuery>.New(
    function : TUniQuery
    var
      i: Byte;
    begin
      Result := TUniQuery.Create(nil);
      Result.Connection := Connection;
      Result.SQL.Text := Statement.AsString;
      if Assigned(Statement.ParamList) then begin
        for i := 0 to Pred(Statement.ParamList.Count) do begin
          Result.ParamByName(Statement.ParamList.Param(i).Name).Value := Statement.ParamList.Param(i).Value;
        end;
      end;
    end
  );
end;

destructor TDBUniQuery.Destroy;
begin
  if Assigned(FQuery)
    then FQuery.Value.Free;
  inherited;
end;

function TDBUniQuery.Edit: IDBQuery;
begin
  Result := Self;
  FQuery.Value.Edit;
end;

function TDBUniQuery.FieldByName(FieldName: string): TField;
begin
  Result := FQuery.Value.FieldByName(FieldName);
end;

function TDBUniQuery.FieldValue(FieldName: string; Value: Variant): IDBQuery;
begin
  Result := Self;
  FQuery.Value.FieldValues[FieldName] := Value;
end;

function TDBUniQuery.ForEach(Action: TRowAction): IDBQuery;
begin
  Result := Self;
  FQuery.Value.First;
  while not Eof do begin
    Action(Self);
    FQuery.Value.Next;
  end;
end;

function TDBUniQuery.GetRecNo: Integer;
begin
  Result := FQuery.Value.RecNo;
end;

function TDBUniQuery.Insert: IDBQuery;
begin
  Result := Self;
  FQuery.Value.Insert;
end;

class function TDBUniQuery.New(Connection: TUniConnection; Statement: ISQLStatement): IDBQuery;
begin
  Result := Create(Connection, Statement);
end;

function TDBUniQuery.RecordCount: Integer;
begin
  Result := TIf<Integer>.New(
    FQuery.Value.Active,
    FQuery.Value.RecordCount,
    0
  ).Eval;
end;

function TDBUniQuery.Run: IDBQuery;
begin
  Result := Self;
  FQuery.Value.Open;
end;

procedure TDBUniQuery.SetRecNo(Idx: Integer);
begin
  FQuery.Value.RecNo := Idx;
end;

{ TDatabase }

function TDBUniDatabase.Connect: IDatabase;
begin
  Result := Self;
  FConnection.Connect;
end;

constructor TDBUniDatabase.Create(Server: IServer; Database: string);
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

class function TDBUniDatabase.New(Server: IServer; Database: string): IDatabase;
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

function TDBUniDatabase.Run(SQLStatement: ISQLStatement): IDatabase;
begin
  Result := Self;
  FConnection.ExecSQL(SQLStatement.AsString, SQLStatement.ParamList.AsVariantArray);
end;

function TDBUniDatabase.StartTransaction: IDatabase;
begin
  FConnection.StartTransaction;
end;

function TDBUniDatabase.StopTransaction(SaveChanges: Boolean = True): IDatabase;
begin
  if SaveChanges then begin
    FConnection.Commit;
  end
  else begin
    FConnection.Rollback;
  end;
end;

end.
