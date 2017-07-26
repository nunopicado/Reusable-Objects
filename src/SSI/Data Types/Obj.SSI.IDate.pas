unit Obj.SSI.IDate;

interface

uses
    Obj.SSI.IValue
  ;

type
  IDate = interface
  ['{26A4BD5E-9220-4687-B246-87A8060A277E}']
    function Value     : TDateTime;
    function AsIString : IString;
    function Age       : IInteger;
  end;

implementation

end.
