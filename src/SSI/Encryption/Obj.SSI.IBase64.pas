unit Obj.SSI.IBase64;

interface

uses
    Obj.SSI.IPrimitive
  ;

type
  {$M+}
  IBase64 = interface
  ['{B8422767-272C-4BB3-9804-FC9ACBD22FBE}']
    function Encode: IString;
    function Decode: IString;
  end;

  IBase64Factory = interface
  ['{5C3BBD8B-199E-480D-ABC8-DFABF9D922A1}']
    function New(const Text: IString): IBase64;
  end;
  {$M-}

implementation

end.
