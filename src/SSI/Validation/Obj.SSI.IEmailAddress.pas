unit Obj.SSI.IEmailAddress;

interface

uses
    Obj.SSI.IValue
  ;

type
  IEmailAddress = interface
  ['{C3F80B3B-D3F0-47B7-BE90-B6EBD0505E8C}']
    function Value: IString;
    function IsValid: Boolean;
  end;

implementation

end.
