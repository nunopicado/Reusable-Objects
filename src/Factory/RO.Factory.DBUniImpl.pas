unit RO.Factory.DBUniImpl;

interface

implementation

uses
    RO.DBConnectionIntf
  , RO.DBUniImpl
  , Spring.Container
  ;

type
  IDatabaseFactory = interface(IInvokable)
  ['{E3813801-C68F-4F80-8081-ACC658A26A3B}']
    function New(Server: IServer; Database: string): IDatabase;
  end;

initialization
  GlobalContainer
    .RegisterType<TDBUniDatabase>('TDBUniDatabase')
    .Implements<IDatabase>;
  GlobalContainer
    .RegisterType<IDatabaseFactory>
    .AsFactory;

end.
