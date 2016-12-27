(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TDBUniDatabase                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(** Classes       : TDBUniDatabase, implements IDatabase                     **)
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
      constructor Create(Server: IServer; Database: String);
      destructor Destroy; Override;
      class function New(Server: IServer; Database: String): IDatabase;
      function Connect: IDatabase;
      function Disconnect: IDatabase;
      function StartTransaction: IDatabase;
      function StopTransaction(SaveChanges: Boolean = True): IDatabase;
      function IsConnected: Boolean;
      function Database: String;
      function NewQuery(Statement: ISQLStatement): IDBQuery;
      function Run(SQLStatement: ISQLStatement): IDatabase;
    End;

    TDatabase = TDBUniDatabase;

implementation

uses
    MySQLUniProvider
  , PostgreSQLUniProvider
  , SQLiteUniProvider
  , SQLServerUniProvider
  ;

type
    TDBUniQuery = class(TInterfacedObject, IDBQuery)
    private
      FQuery: TUniQuery;
      FStatement : ISQLStatement;
      FConnection: TUniConnection;
    public
      constructor Create(Connection: TUniConnection; Statement: ISQLStatement);
      destructor Destroy; Override;
      class function New(Connection: TUniConnection; Statement: ISQLStatement): IDBQuery;
      function Publish(DataSource: TDataSource): IDBQuery;
      function RecordCount: Integer;
      function RecNo(Idx: Integer): IDBQuery;
      function FieldByName(FieldName: String): TField;
      function ForEach(Action: TRowAction): IDBQuery;
      function Run: IDBQuery;
      function Insert: IDBQuery;
      function Edit: IDBQuery;
      function Append: IDBQuery;
      function Post: IDBQuery;
      function FieldValue(FieldName: String; Value: Variant): IDBQuery;
    End;

{ TDBUniQuery }

function TDBUniQuery.Post: IDBQuery;
begin
     Result := Self;
     FQuery.Post;
end;

function TDBUniQuery.Publish(DataSource: TDataSource): IDBQuery;
begin
     Result := Self;
     DataSource.DataSet := FQuery;
end;

function TDBUniQuery.Append: IDBQuery;
begin
     Result := Self;
     FQuery.Append;
end;

constructor TDBUniQuery.Create(Connection: TUniConnection; Statement: ISQLStatement);
begin
     FConnection := Connection;
     FStatement  := Statement;
end;

destructor TDBUniQuery.Destroy;
begin
     if Assigned(FQuery)
        then FQuery.Free;
     inherited;
end;

function TDBUniQuery.Edit: IDBQuery;
begin
     Result := Self;
     FQuery.Edit;
end;

function TDBUniQuery.FieldByName(FieldName: String): TField;
begin
     Result := FQuery.FieldByName(FieldName);
end;

function TDBUniQuery.FieldValue(FieldName: String; Value: Variant): IDBQuery;
begin
     Result := Self;
     FQuery.FieldValues[FieldName] := Value;
end;

function TDBUniQuery.ForEach(Action: TRowAction): IDBQuery;
begin
     Result := Self;
     FQuery.First;
     while not Eof do
           begin
                Action(FQuery.RecNo);
                FQuery.Next;
           end;
end;

function TDBUniQuery.Insert: IDBQuery;
begin
     Result := Self;
     FQuery.Insert;
end;

class function TDBUniQuery.New(Connection: TUniConnection; Statement: ISQLStatement): IDBQuery;
begin
     Result := Create(Connection, Statement);
end;

function TDBUniQuery.RecNo(Idx: Integer): IDBQuery;
begin
     Result       := Self;
     FQuery.RecNo := Idx;
end;

function TDBUniQuery.RecordCount: Integer;
begin
     Result := FQuery.RecordCount;
end;

function TDBUniQuery.Run: IDBQuery;
  procedure LoadParams;
  var
     i: Byte;
  begin
       if Assigned(FStatement.ParamList)
          then for i := 0 to FStatement.ParamList.Count-1 do
                   FQuery.ParamByName(FStatement.ParamList.Param(i).Name).Value := FStatement.ParamList.Param(i).Value;
  end;
begin
     Result := Self;
     if not Assigned(FQuery)
        then begin
                  FQuery            := TUniQuery.Create(nil);
                  FQuery.Connection := FConnection;
             end
        else FQuery.Close;
     FQuery.SQL.Text := FStatement.AsString;
     LoadParams;
     FQuery.Open;
end;

{ TDatabase }

function TDBUniDatabase.Connect: IDatabase;
begin
     Result := Self;
     FConnection.Connect;
end;

constructor TDBUniDatabase.Create(Server: IServer; Database: String);
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

function TDBUniDatabase.Database: String;
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

class function TDBUniDatabase.New(Server: IServer; Database: String): IDatabase;
begin
     Result := Create(Server, Database);
end;

function TDBUniDatabase.NewQuery(Statement: ISQLStatement): IDBQuery;
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
     if SaveChanges
        then FConnection.Commit
        else FConnection.Rollback;
end;

end.
