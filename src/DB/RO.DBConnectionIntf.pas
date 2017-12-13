(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDatabase                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ISQLParam, ISQLParamFactory                              **)
(**                 ISQLParams, ISQLParamsFactory                            **)
(**                 ISQLStatement, ISQLStatementFactory                      **)
(**                 IServer                                                  **)
(**                 IDBQuery                                                 **)
(**                 IDatabase, IDatabaseFactory                              **)
(******************************************************************************)
(** Enumerators   : TServerType                                              **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   : TRowAction, TVariantArray                                **)
(******************************************************************************)
(** Dependencies  : VCL                                                      **)
(******************************************************************************)
(** Description   : An interface suite to generalize DB Connections          **)
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

unit RO.DBConnectionIntf;

interface

uses
    SysUtils
  , DB
  ;

type
  IDBQuery      = interface;
  TRowAction    = Reference to procedure (This: IDBQuery);
  TServerType   = (stMySQL, stMSSQL, stSQLite, stPostgreSQL);
  TVariantArray = array of Variant;

  ISQLParam = interface(IInvokable)
  ['{C531EB68-5157-49E1-A498-42652239A3D7}']
    function Name: string;
    function Value: Variant;
  end;

  ISQLParams = interface(IInvokable)
  ['{00AA5AE7-233B-4B7B-827B-7DF90B8A8315}']
    function Add(Param: ISQLParam): ISQLParams;
    function Param(Idx: Integer): ISQLParam;
    function AsVariantArray: TVariantArray;
    function Count: Integer;
  end;

  ISQLStatement = interface(IInvokable)
  ['{5B75AF96-FD85-465E-86DD-D537B90FA381}']
    function ParamList: ISQLParams;
    function AsString: string;
  end;

  IServer = interface(IInvokable)
  ['{5C49AC74-D4C1-4C73-AF4A-140FCE379F63}']
    function Hostname: string;
    function Port: Word;
    function Username: string;
    function Password: string;
    function ServerType: TServerType;
    function TypeAsString: string;
  end;

  IDBQuery = interface(IInvokable)
  ['{9E4D3D8E-BE29-43CE-8A5E-2F1C9C5E58D0}']
    procedure SetRecNo(Idx: Integer);
    function GetRecNo: Integer;
    function Publish(DataSource: TDataSource): IDBQuery;
    function RecordCount: Integer;
    function FieldByName(FieldName: string): TField;
    function ForEach(Action: TRowAction): IDBQuery;
    function Run: IDBQuery;
    function Insert: IDBQuery;
    function Edit: IDBQuery;
    function Append: IDBQuery;
    function Post: IDBQuery;
    function FieldValue(FieldName: String; Value: Variant): IDBQuery;
    property RecNo: Integer
      read GetRecNo
      write SetRecNo;
  end;

  IDatabase = interface(IInvokable)
  ['{4427B094-79C4-44B6-B322-A26D0FD8BD60}']
    function Connect: IDatabase;
    function Disconnect: IDatabase;
    function IsConnected: Boolean;
    function StartTransaction: IDatabase;
    function StopTransaction(SaveChanges: Boolean = True): IDatabase;
    function Database: string;
    function NewQuery(const Statement: ISQLStatement): IDBQuery; overload;
    function NewQuery(const Statement: ISQLStatement; out Destination: IDBQuery): IDatabase; overload;
    function Run(SQLStatement: ISQLStatement): IDatabase;
  end;

implementation

end.
