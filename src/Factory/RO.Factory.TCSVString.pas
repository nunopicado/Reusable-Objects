unit RO.Factory.TCSVString;

interface

implementation

uses
    RO.ICSVString
  , RO.TCSVString
  , Spring.Container
  ;

type
  ICSVStringFactory = interface(IInvokable)
  ['{4B0630D1-1F19-4F32-BB4E-1CC6B56600C2}']
    function New(const CSVString: string; const Delimiter: Char): ICSVString; overload;
    function New(const CSVString: string): ICSVString; overload;
  end;

initialization
  GlobalContainer
    .RegisterType<TCSVString>('TCSVString')
    .Implements<ICSVString>;
  GlobalContainer
    .RegisterType<ICSVStringFactory>
    .AsFactory;

end.
