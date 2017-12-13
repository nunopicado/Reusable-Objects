unit RO.VCL.IColor;

interface

uses
    Graphics
  ;

type
  IColor = interface(IInvokable)
  ['{D7B2C6A2-C54B-4E6C-9291-072D9AEFA5F8}']
    function AsTColor: TColor;
  end;

  IColorFactory = interface(IInvokable)
  ['{027D050D-2D9C-460E-BAC6-B4B8E0BB8F21}']
    function New(Color: string): IColor;
  end;

implementation

end.
