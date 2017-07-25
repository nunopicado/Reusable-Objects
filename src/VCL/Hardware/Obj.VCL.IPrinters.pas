unit Obj.VCL.IPrinters;

interface

uses
    Obj.SSI.IPrimitive
  , Spring.Collections
  ;

type
  IPrinters = interface
  ['{AD15718B-BFAD-4094-87A5-440C430A5709}']
    function SendSequence(const Sequence: IList<Byte>): IPrinters;
    function AsList(const List: IList<String>): IPrinters;
    function Select(const Name: IString): IPrinters;
    function Default: IString;
  end;

implementation

end.
