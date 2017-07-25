unit Obj.SSI.IRange;

interface

type
  IRange<T: record> = interface
  ['{5FE5BB8E-F241-4A84-BFF7-555BA9320A2D}']
    function Includes(const Value: T): Boolean;
    function Excludes(const Value: T): Boolean;
  end;

  IIntegerRange = IRange<Int64>;
  IFloatRange = IRange<Extended>;
  ICharRange = IRange<Char>;

implementation

end.
