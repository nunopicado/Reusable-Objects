unit Obj.SSI.TPrimitive;

interface

uses
    Obj.SSI.IPrimitive
  ;

type
  TPrimitive<T> = class(TInterfacedObject, IPrimitive<T>)
  private
    FValue: T;
  public
    constructor Create(Value: T);
    class function New(Value: T): IPrimitive<T>;
    function Value: T;
  end;

  TBoolean  = TPrimitive<Boolean>;
  TChar     = TPrimitive<Char>;
  TString   = TPrimitive<string>;
  TByte     = TPrimitive<Byte>;
  TWord     = TPrimitive<Word>;
  TLongWord = TPrimitive<LongWord>;
  TInteger  = TPrimitive<Integer>;
  TInt64    = TPrimitive<Int64>;
  TReal     = TPrimitive<Real>;
  TSingle   = TPrimitive<Single>;
  TDouble   = TPrimitive<Double>;
  TCurrency = TPrimitive<Currency>;

implementation

{ TPrimitive<T> }

constructor TPrimitive<T>.Create(Value: T);
begin
  FValue := Value;
end;

class function TPrimitive<T>.New(Value: T): IPrimitive<T>;
begin
  Result := Create(Value);
end;

function TPrimitive<T>.Value: T;
begin
  Result := FValue;
end;

end.
