unit Obj.SSI.IIf;

interface

type
  {$M+}
  IIf<T> = interface
  ['{4EC97D4A-BF07-4309-BE24-784424D12529}']
    function Eval: T;
  End;

  IIfFactory<T> = interface
  ['{8D8FA9F1-A9C1-4182-9117-A402FE966F28}']
    function New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIf<T>;
  end;
  {$M-}

implementation

end.
