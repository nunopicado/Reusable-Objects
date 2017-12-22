unit RO.Factory.DBGenericImpl;

interface

uses
    RO.DBConnectionIntf
  ;

type
  ISQLParamFactory = interface(IInvokable)
  ['{66A73342-5CF0-4A41-A292-687468A2CE0C}']
    function New(const Name: string; const Value: Variant): ISQLParam;
  end;

  ISQLParamsFactory = interface(IInvokable)
  ['{85A7B252-F5A4-4122-AC16-466D5F4F29B2}']
    function New: ISQLParams; overload;
    function New(const Param: ISQLParam): ISQLParams; overload;
  end;

  ISQLStatementFactory = interface(IInvokable)
  ['{50297042-E69D-4AEA-B590-BF4EED66F711}']
    function New(const Statement: string; const Params: ISQLParams): ISQLStatement; overload;
    function New(const Statement: string): ISQLStatement; overload;
  end;

  IServerFactory = interface(IInvokable)
  ['{1068C1DE-80BE-4D8E-A690-0B78B0E4EC90}']
    function New(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType): IServer;
  end;

implementation

uses
    RO.DBGenericImpl
  , Spring.Container
  ;

initialization
  GlobalContainer
    .RegisterType<TSQLParam>('TSQLParam')
    .Implements<ISQLParam>;
  GlobalContainer
    .RegisterType<ISQLParamFactory>
    .AsFactory;
  GlobalContainer
    .RegisterType<TSQLParams>('TSQLParams')
    .Implements<ISQLParams>;
  GlobalContainer
    .RegisterType<ISQLParamsFactory>
    .AsFactory;
  GlobalContainer
    .RegisterType<TSQLStatement>('TSQLStatement')
    .Implements<ISQLStatement>;
  GlobalContainer
    .RegisterType<ISQLStatementFactory>
    .AsFactory;
  GlobalContainer
    .RegisterType<TServer>('TServer')
    .Implements<IServer>;
  GlobalContainer
    .RegisterType<IServerFactory>
    .AsFactory;

end.
