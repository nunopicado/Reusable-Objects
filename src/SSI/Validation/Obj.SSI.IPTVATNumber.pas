unit Obj.SSI.IPTVATNumber;

interface

uses
    Obj.SSI.IValue
  ;

type
  IPTVATNumber = interface
  ['{60BEF117-FF0B-4F36-A69E-A8CB147EF87C}']
    function IsValid: Boolean;
    function AsIString: IString;
    function AsIInteger: IInteger;
  end;

implementation

end.
