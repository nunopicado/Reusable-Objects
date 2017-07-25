unit Obj.SSI.ICryptString;

interface

uses
    Obj.SSI.IPrimitive
  ;

type
  {$M+}
  ICryptString = interface
  ['{98C9E3C7-230A-4718-9BB8-0E0B1B40BBE5}']
    function Crypt: IString;
    function Decrypt: IString;
  end;

  ICryptStringFactory = interface
  ['{7700A319-F560-42CC-B10F-E703BB791E89}']
    function New(const Text: IString): ICryptString; overload;
    function New(const Text, Password: IString): ICryptString; overload;
  end;
  {$M-}

implementation

end.
