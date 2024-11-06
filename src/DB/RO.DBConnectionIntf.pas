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
(** Other types   : TVariantArray                                            **)
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
  TServerType   = (stMySQL, stMSSQL, stSQLite, stPostgreSQL);
  TVariantArray = array of Variant;

  ISQLStatement = interface(IInvokable)
  ['{5B75AF96-FD85-465E-86DD-D537B90FA381}']
    function Statement: string;
    function Params: TVariantArray;
    function ParamCount: Integer;
  end;

  IServerInfo = interface(IInvokable)
  ['{5C49AC74-D4C1-4C73-AF4A-140FCE379F63}']
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

  IServerInfoUpdate = interface(IInvokable)
  ['{7B023BE2-B7DA-4519-9FD5-ED7F93F7EE33}']
    function Update(const HostName: string; const Port: Word; const Username, Password, Database: string; ServerType: TServerType;
      const BinPath, UpdatePath: string): IServerInfoUpdate;
  end;

  IQuery = interface(IInvokable)
  ['{9E4D3D8E-BE29-43CE-8A5E-2F1C9C5E58D0}']
    function Run: IQuery;
    function Open: IQuery;
    function Close: IQuery;
    function ReadOnly(const Value: Boolean): IQuery;
    function SetMasterSource(const MasterSource: TDataSource): IQuery;
    function AddMasterDetailLink(const Master, Detail: string; const Index: string = ''): IQuery;
    function UpdateSQL(const Statement: ISQLStatement): IQuery;
    function DeleteSQL(const Statement: ISQLStatement): IQuery;
    function InsertSQL(const Statement: ISQLStatement): IQuery;
    function RefreshSQL(const Statement: ISQLStatement): IQuery;
    function LockSQL(const Statement: ISQLStatement): IQuery;
    function ForEach(const Row: TProc<TDataset>): IQuery;
    function AsDataset: TDataset;
    function AsJSON(const ForceArray: Boolean = true): string;
  end;

  IDatabase = interface(IInvokable)
  ['{4427B094-79C4-44B6-B322-A26D0FD8BD60}']
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

implementation

end.

