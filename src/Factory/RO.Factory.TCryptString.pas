unit RO.Factory.TCryptString;

interface

uses
    RO.ICryptString
  , RO.IValue
  ;

type
  ICryptStringFactory = interface(IInvokable)
  ['{7700A319-F560-42CC-B10F-E703BB791E89}']
    function New(const Text: IAnsiString): ICryptString; overload;
    function New(const Text, Password: IAnsiString): ICryptString; overload;
  end;

implementation

uses
    RO.TCryptString
  , Spring.Container
  ;

initialization
  GlobalContainer
    .RegisterType<TCryptString>('TCryptString')
    .Implements<ICryptString>;
  GlobalContainer
    .RegisterType<ICryptStringFactory>
    .AsFactory;

end.
