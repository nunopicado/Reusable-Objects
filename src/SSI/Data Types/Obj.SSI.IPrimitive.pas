unit Obj.SSI.IPrimitive;

interface

type
  {$M+}
  IPrimitive<T> = interface
  ['{21E1AA41-099A-49FA-8C9B-2CA3A37BAD25}']
    function Value: T;
  end;
  {$M-}

  IBoolean  = IPrimitive<Boolean>;
  IChar     = IPrimitive<Char>;
  IString   = IPrimitive<string>;
  IByte     = IPrimitive<Byte>;
  IWord     = IPrimitive<Word>;
  ILongWord = IPrimitive<LongWord>;
  IInteger  = IPrimitive<Integer>;
  IInt64    = IPrimitive<Int64>;
  IReal     = IPrimitive<Real>;
  ISingle   = IPrimitive<Single>;
  IDouble   = IPrimitive<Double>;
  ICurrency = IPrimitive<Currency>;

implementation

end.
