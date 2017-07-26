unit Obj.SSI.IValue;

interface

type
  IValue<T> = interface(IInvokable)
  ['{21E1AA41-099A-49FA-8C9B-2CA3A37BAD25}']
    function Value: T;
  end;

  IBoolean  = IValue<Boolean>;
  IChar     = IValue<Char>;
  IString   = IValue<string>;
  IByte     = IValue<Byte>;
  IWord     = IValue<Word>;
  ILongWord = IValue<LongWord>;
  IInteger  = IValue<Integer>;
  IInt64    = IValue<Int64>;
  IReal     = IValue<Real>;
  ISingle   = IValue<Single>;
  IDouble   = IValue<Double>;
  ICurrency = IValue<Currency>;

implementation

end.
