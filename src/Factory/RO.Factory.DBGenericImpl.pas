unit RO.Factory.DBGenericImpl;

interface

implementation

uses
    RO.DBConnectionIntf
  , RO.DBGenericImpl
  , Spring.Container
  ;

type
  ISQLParamFactory = interface(IInvokable)
  ['{66A73342-5CF0-4A41-A292-687468A2CE0C}']
    function New(Name: string; Value: Variant): ISQLParam;
  end;

  ISQLParamsFactory = interface(IInvokable)
  ['{85A7B252-F5A4-4122-AC16-466D5F4F29B2}']
    function New: ISQLParams; overload;
    function New(Param: ISQLParam): ISQLParams; overload;
  end;

  ISQLStatementFactory = interface(IInvokable)
  ['{50297042-E69D-4AEA-B590-BF4EED66F711}']
    function New(Statement: string; Params: ISQLParams): ISQLStatement; overload;
    function New(Statement: string): ISQLStatement; overload;
  end;

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

end.
