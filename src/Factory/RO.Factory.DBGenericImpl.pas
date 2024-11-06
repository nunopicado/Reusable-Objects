unit RO.Factory.DBGenericImpl;

interface

uses
    RO.DBConnectionIntf
  ;

type
  ISQLStatementFactory = interface(IInvokable)
  ['{50297042-E69D-4AEA-B590-BF4EED66F711}']
    function New(const Statement: string; const Params: TVariantArray): ISQLStatement; overload;
    function New(const Statement: string): ISQLStatement; overload;
  end;

  IServerInfoFactory = interface(IInvokable)
  ['{1068C1DE-80BE-4D8E-A690-0B78B0E4EC90}']
    function New(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType): IServerInfo; overload;
    function New(const HostName: string; const Port: Word; const Username, Password: string; const ServerType: TServerType; const Database, BinPath, UpdatePath: string): IServerInfo; overload;
  end;

implementation

uses
    RO.DBGenericImpl
  , Spring.Container
  ;

initialization
  GlobalContainer
    .RegisterType<TSQLStatement>('TSQLStatement')
    .Implements<ISQLStatement>;
  GlobalContainer
    .RegisterType<ISQLStatementFactory>
    .AsFactory;
  GlobalContainer
    .RegisterType<TServerInfo>('TServerInfo')
    .Implements<IServerInfo>;
  GlobalContainer
    .RegisterType<IServerInfoFactory>
    .AsFactory;

end.
