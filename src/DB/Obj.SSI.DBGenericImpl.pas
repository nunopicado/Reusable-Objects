(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TServer                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(** Classes       : TServer, implements IServer                              **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
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

unit Obj.SSI.DBGenericImpl;

interface

uses
    Obj.SSI.DBConnectionIntf
  , System.Generics.Collections
  ;

type
    TServer = class(TInterfacedObject, IServer)
    private
      FHostname: String;
      FPort: Word;
      FUsername: String;
      FPassword: String;
      FServerType: TServerType;
    public
      constructor Create(const HostName: String; const Port: Word; const Username, Password: String; ServerType: TServerType);
      class function New(const HostName: String; const Port: Word; const Username, Password: String; ServerType: TServerType): IServer;
      function Hostname: String;
      function Port: Word;
      function Username: String;
      function Password: String;
      function ServerType: TServerType;
      function TypeAsString: String;
    End;

    TSQLStatement = Class(TInterfacedObject, ISQLStatement)
    strict private
      FStatement: String;
      FParamList: ISQLParams;
    public
      constructor Create(Statement: String; Params: ISQLParams);
      class function New(Statement: String; Params: ISQLParams): ISQLStatement; Overload;
      class function New(Statement: String): ISQLStatement; Overload;
      function ParamList: ISQLParams;
      function AsString: String;
    End;

    TSQLParam = class(TInterfacedObject, ISQLParam)
    strict private
      FName: String;
      FValue: Variant;
    public
      constructor Create(Name: String; Value: Variant);
      class function New(Name: String; Value: Variant): ISQLParam;
      function Name: String;
      function Value: Variant;
    End;

    TSQLParams = class(TInterfacedObject, ISQLParams)
    strict private
      FList: TList<ISQLParam>;
    public
      constructor Create;
      class function New: ISQLParams; Overload;
      class function New(Param: ISQLParam): ISQLParams; Overload;
      function Add(Param: ISQLParam): ISQLParams;
      function Param(Idx: Integer): ISQLParam;
      function AsVariantArray: TVariantArray;
      function Count: Integer;
    End;

implementation

uses
    SysUtils
  ;

{ TServer }

constructor TServer.Create(const HostName: String; const Port: Word; const Username, Password: String;
  ServerType: TServerType);
begin
     FHostname   := HostName;
     FPort       := Port;
     FUsername   := Username;
     FPassword   := Password;
     FServerType := ServerType;
end;

function TServer.Hostname: String;
begin
     Result := FHostname;
end;

class function TServer.New(const HostName: String; const Port: Word; const Username, Password: String;
  ServerType: TServerType): IServer;
begin
     Result := Create(HostName, Port, Username, Password, ServerType);
end;

function TServer.Password: String;
begin
     Result := FPassword;
end;

function TServer.Port: Word;
begin
     Result := FPort;
end;

function TServer.ServerType: TServerType;
begin
     Result := FServerType;
end;

function TServer.TypeAsString: String;
begin
     case FServerType of
          stMySQL      : Result := 'MySQL';
          stMSSQL      : Result := 'SQL Server';
          stSQLite     : Result := 'SQLite';
          stPostgreSQL : Result := 'PostgreSQL';
     else raise Exception.Create('Unknown Server Type');
     end;
end;

function TServer.Username: String;
begin
     Result := FUsername;
end;

{ TSQLStatement }

function TSQLStatement.AsString: String;
begin
     Result := FStatement;
end;

constructor TSQLStatement.Create(Statement: String; Params: ISQLParams);
begin
     FStatement := Statement;
     FParamList := Params;
end;

class function TSQLStatement.New(Statement: String): ISQLStatement;
begin
     Result := New(Statement, nil);
end;

class function TSQLStatement.New(Statement: String; Params: ISQLParams): ISQLStatement;
begin
     Result := Create(Statement, Params);
end;

function TSQLStatement.ParamList: ISQLParams;
begin
     Result := FParamList;
end;

{ TSQLParam }

constructor TSQLParam.Create(Name: String; Value: Variant);
begin
     FName  := Name;
     FValue := Value;
end;

function TSQLParam.Name: String;
begin
     Result := FName;
end;

class function TSQLParam.New(Name: String; Value: Variant): ISQLParam;
begin
     Result := Create(Name, Value);
end;

function TSQLParam.Value: Variant;
begin
     Result := FValue;
end;

{ TSQLParams }

function TSQLParams.Add(Param: ISQLParam): ISQLParams;
begin
     Result := Self;
     FList.Add(Param);
end;

function TSQLParams.AsVariantArray: TVariantArray;
var
   i: Integer;
   Param: ISQLParam;
begin
     SetLength(Result, FList.Count * 2);
     if FList.Count>0
        then for i := 0 to FList.Count-1 do
                 begin
                      Result[(i+1)*2-2] := FList[i].Name;
                      Result[(i+1)*2-1] := FList[i].Value;
                 end;
end;

function TSQLParams.Count: Integer;
begin
     Result := FList.Count;
end;

constructor TSQLParams.Create;
begin
     FList := TList<ISQLParam>.Create;
end;

class function TSQLParams.New: ISQLParams;
begin
     Result := Create;
end;

class function TSQLParams.New(Param: ISQLParam): ISQLParams;
begin
     Result := Create.Add(Param);
end;

function TSQLParams.Param(Idx: Integer): ISQLParam;
begin
     if FList.Count>0
        then Result := FList[Idx];
end;

end.
