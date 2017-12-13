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

implementation

end.
