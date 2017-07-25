unit Obj.SSI.ICurrency;

interface

type
  ICurrency = Interface
  ['{EF61CB53-7281-4645-B3C5-C5EE860FC2C5}']
    function Value: Currency;
    function AsString: String;
    function Add(const Value: Currency): ICurrency;
    function Sub(const Value: Currency): ICurrency;
    function Reset: ICurrency;
  end;

implementation

end.
