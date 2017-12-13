unit RO.Factory.THexColor;

interface

uses
    RO.VCL.IColor
  ;

type
  IHexColorFactory = interface(IInvokable)
  ['{027D050D-2D9C-460E-BAC6-B4B8E0BB8F21}']
    function New(const Color: string): IColor;
  end;

implementation

uses
    RO.VCL.THexColor
  , Spring.Container
  ;

initialization
  GlobalContainer
    .RegisterType<THexColor>('THexColor')
    .Implements<IColor>;
  GlobalContainer
    .RegisterType<IHexColorFactory>
    .AsFactory;

end.
