unit Obj.SSI.IEnum;

interface

type
  IEnum<TEnumerator: Record> = interface
  ['{81A660A7-744C-4BA2-A2C5-113EC5C8D976}']
    function AsString  : string;
    function AsInteger : Integer;
    function AsEnum    : TEnumerator;
  End;

implementation

end.
