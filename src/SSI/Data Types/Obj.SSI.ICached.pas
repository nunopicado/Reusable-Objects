unit Obj.SSI.ICached;

interface

type
  TDefineCached<T> = Reference to function: T;

  ICached<T> = Interface(IInvokable)
    function Value: T;
  End;

  ICachedBoolean  = ICached<Boolean>;
  ICachedChar     = ICached<Char>;
  ICachedString   = ICached<string>;
  ICachedByte     = ICached<Byte>;
  ICachedWord     = ICached<Word>;
  ICachedLongWord = ICached<LongWord>;
  ICachedInteger  = ICached<Integer>;
  ICachedInt64    = ICached<Int64>;
  ICachedReal     = ICached<Real>;
  ICachedSingle   = ICached<Single>;
  ICachedDouble   = ICached<Double>;
  ICachedCurrency = ICached<Currency>;

implementation

end.
