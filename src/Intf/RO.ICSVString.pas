unit RO.ICSVString;

interface

type
  ICSVString = interface(IInvokable)
  ['{3995FCE9-5ED4-49EB-A4BB-6CB6A787CC1A}']
    function Count: Byte;
    function Field(const FieldNumber: Byte; const Default: string = ''): string;
  end;

implementation

end.
