unit RO.Factory.DBUniImpl;

interface

uses
    RO.DBConnectionIntf
  ;

type
  IDatabaseFactory = interface(IInvokable)
  ['{E3813801-C68F-4F80-8081-ACC658A26A3B}']
    function New(const ServerInfo: IServerInfo): IDatabase;
  end;

implementation

uses
    RO.DBUniImpl
  , Spring.Container
  ;

initialization
  GlobalContainer
    .RegisterType<TDatabase>('TDatabase')
    .Implements<IDatabase>
    .AsSingleton;
  GlobalContainer
    .RegisterType<IDatabaseFactory>
    .AsFactory;

finalization
  GlobalContainer
    .Resolve<IDatabase>.Disconnect;

end.
