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
  , RO.IValue
  , System.Generics.Collections
  , SysUtils
  , DB
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

  TDummyDatabase = class(TInterfacedObject, IDatabase)
  strict private
    FConnectAction: TProc;
  public
    constructor Create(const ConnectAction: TProc = nil);
    class function New(const ConnectAction: TProc = nil): IDatabase;
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function IsConnected: Boolean;
    function OnReconnect(Action: TProc): IDatabase; virtual; abstract;
    function OnDisconnect(Action: TProc): IDatabase; virtual; abstract;
    function StartTransaction: IDatabase; virtual; abstract;
    function StopTransaction(const SaveChanges: Boolean = True): IDatabase; virtual; abstract;
    function Query(const Statement: ISQLStatement): IQuery; virtual; abstract;
    function Execute(const SQLStatement: ISQLStatement): IDatabase; virtual; abstract;
    function ServerInfo: IServerInfo; virtual; abstract;
  end;

  TDatasetAsJSON = class(TInterfacedObject, IString)
  private
    FJSON: IString;
  public
    constructor Create(const Dataset: TDataset; const ForceArray: Boolean = True);
    class function New(const Dataset: TDataset; const ForceArray: Boolean = True): IString;
    function Value: string;
    function Refresh: IValue<string>;
  end;

implementation

uses
    RO.TValue
  , System.JSON
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

{ TDummyDatabase }

function TDummyDatabase.Connect: IDatabase;
begin
  Result := Self;
  if Assigned(FConnectAction)
    then FConnectAction;
end;

constructor TDummyDatabase.Create(const ConnectAction: TProc);
begin
  FConnectAction := ConnectAction;
end;

function TDummyDatabase.Disconnect: IDatabase;
begin
  Result := Self;
end;

function TDummyDatabase.IsConnected: Boolean;
begin
  Result := False;
end;

class function TDummyDatabase.New(const ConnectAction: TProc = nil): IDatabase;
begin
  Result := Create(ConnectAction);
end;

{ TDatasetAsJSON }

constructor TDatasetAsJSON.Create(const Dataset: TDataset; const ForceArray: Boolean = True);
begin
  FJSON := TString.New(
    function : string
      function RowToJSONObject: TJSONObject;
      var
        Field: TField;
      begin
        Result := TJSONObject.Create;
        for Field in DataSet.Fields do
          case Field.DataType of
            ftString  : Result.AddPair(Field.FieldName, TJSONString.Create(Field.AsString));
            ftInteger : Result.AddPair(Field.FieldName, TJSONNumber.Create(Field.AsInteger));
            ftBoolean :
              if Field.AsBoolean
                then Result.AddPair(Field.FieldName, TJSONFalse.Create)
                else Result.AddPair(Field.FieldName, TJSONTrue.Create);
            else Result.AddPair(Field.FieldName, TJSONString.Create(Field.AsString));
          end;
      end;
    var
      JSONArray : TJSONArray;
    begin
      DataSet.First;
      if
         (Dataset.RecordCount > 1) or
          ForceArray
        then begin
          JSONArray := TJSONArray.Create;
          try
            while not DataSet.Eof do
              begin
                JSONArray.AddElement(RowToJSONObject);
                DataSet.Next;
              end;
            Result := JSONArray.ToJSON;
          finally
            JSONArray.Free;
          end;
        end
        else begin
          with RowToJSONObject do
            begin
              Result := ToJSON;
              Free;
            end;
        end;
    end
  );
end;

class function TDatasetAsJSON.New(const Dataset: TDataset; const ForceArray: Boolean = True): IString;
begin
  Result := Create(Dataset, ForceArray);
end;

function TDatasetAsJSON.Refresh: IValue<string>;
begin
  Result := Self;
  FJSON.Refresh;
end;

function TDatasetAsJSON.Value: string;
begin
  Result := FJSON.Value;
end;

end.
