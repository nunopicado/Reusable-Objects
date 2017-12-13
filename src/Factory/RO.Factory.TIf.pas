unit RO.Factory.TIf;

interface

uses
    RO.IIf
  ;

type
  IIfFactory<T> = interface(IInvokable)
  ['{8D8FA9F1-A9C1-4182-9117-A402FE966F28}']
    function New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIf<T>;
  end;

implementation

end.
