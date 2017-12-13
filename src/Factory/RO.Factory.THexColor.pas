unit RO.Factory.THexColor;

interface

implementation

uses
    RO.VCL.IColor
  , RO.VCL.THexColor
  , Spring.Container
  ;

type
  IHexColorFactory = interface(IInvokable)
  ['{027D050D-2D9C-460E-BAC6-B4B8E0BB8F21}']
    function New(const Color: string): IColor;
  end;

initialization
  GlobalContainer
    .RegisterType<THexColor>('THexColor')
    .Implements<IColor>;
  GlobalContainer
    .RegisterType<IHexColorFactory>
    .AsFactory;

end.
