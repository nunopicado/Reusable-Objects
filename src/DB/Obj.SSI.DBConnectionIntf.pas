(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDBQuery, ISQLParam, ISQLParams, ISQLStatement, IServer, **)
(**                 IDatabase                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ISQLParam, ISQLParams, ISQLStatement, IServer, IDBQuery, **)
(**                 IDatabase                                                **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
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

unit Obj.SSI.DBConnectionIntf;

interface

uses
    SysUtils
  , DB
  ;

type
    IDBQuery      = Interface;
    TRowAction    = Reference to procedure (This: IDBQuery);
    TServerType   = (stMySQL, stMSSQL, stSQLite, stPostgreSQL);
    TVariantArray = Array of Variant;

    {$M+}
    ISQLParam = Interface ['{C531EB68-5157-49E1-A498-42652239A3D7}']
      function Name: String;
      function Value: Variant;
    End;

    ISQLParams = Interface ['{00AA5AE7-233B-4B7B-827B-7DF90B8A8315}']
      function Add(Param: ISQLParam): ISQLParams;
      function Param(Idx: Integer): ISQLParam;
      function AsVariantArray: TVariantArray;
      function Count: Integer;
    End;

    ISQLStatement = Interface ['{5B75AF96-FD85-465E-86DD-D537B90FA381}']
      function ParamList: ISQLParams;
      function AsString: String;
    End;

    IServer = Interface ['{5C49AC74-D4C1-4C73-AF4A-140FCE379F63}']
      function Hostname: String;
      function Port: Word;
      function Username: String;
      function Password: String;
      function ServerType: TServerType;
      function TypeAsString: String;
    End;

    IDBQuery = Interface ['{9E4D3D8E-BE29-43CE-8A5E-2F1C9C5E58D0}']
      procedure SetRecNo(Idx: Integer);
      function GetRecNo: Integer;
      function Publish(DataSource: TDataSource): IDBQuery;
      function RecordCount: Integer;
      function FieldByName(FieldName: String): TField;
      function ForEach(Action: TRowAction): IDBQuery;
      function Run: IDBQuery;
      function Insert: IDBQuery;
      function Edit: IDBQuery;
      function Append: IDBQuery;
      function Post: IDBQuery;
      function FieldValue(FieldName: String; Value: Variant): IDBQuery;
      property RecNo: Integer read GetRecNo write SetRecNo;
    End;

    IDatabase = Interface ['{4427B094-79C4-44B6-B322-A26D0FD8BD60}']
      function Connect: IDatabase;
      function Disconnect: IDatabase;
      function IsConnected: Boolean;
      function StartTransaction: IDatabase;
      function StopTransaction(SaveChanges: Boolean = True): IDatabase;
      function Database: String;
      function NewQuery(Statement: ISQLStatement): IDBQuery;
      function Run(SQLStatement: ISQLStatement): IDatabase;
    End;
    {$M-}

implementation

end.
