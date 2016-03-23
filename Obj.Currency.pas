unit Obj.Currency;

interface

type
    ICurrency = Interface             ['{EF61CB53-7281-4645-B3C5-C5EE860FC2C5}']
      function AsCurrency: Currency;
      function AsString: String;
      function Add(Value: Currency): ICurrency;
      function Sub(Value: Currency): ICurrency;
      function Reset: ICurrency;
    End;

    TCurrency = Class(TInterfacedObject, ICurrency)
    private
      FValue: Currency;
      constructor Create(InitialValue: Currency); Overload;
    public
      class function New(InitialValue: Currency): ICurrency;
      function AsCurrency: Currency;
      function AsString: String;
      function Add(Value: Currency): ICurrency;
      function Sub(Value: Currency): ICurrency;
      function Reset: ICurrency;
    End;

implementation

uses
    SysUtils;


{ TCurrency }

function TCurrency.Add(Value: Currency): ICurrency;
begin
     FValue := FValue + Value;
     Result := Self;
end;

function TCurrency.AsCurrency: Currency;
begin
     Result := FValue;
end;

function TCurrency.AsString: String;
begin
     Result := CurrToStrF(FValue, ffCurrency, FormatSettings.CurrencyDecimals);
end;

constructor TCurrency.Create(InitialValue: Currency);
begin
     inherited Create;
     FValue := InitialValue;
end;

class function TCurrency.New(InitialValue: Currency): ICurrency;
begin
     Result := Create(InitialValue);
end;

function TCurrency.Reset: ICurrency;
begin
     FValue := 0;
     Result := Self;
end;

function TCurrency.Sub(Value: Currency): ICurrency;
begin
     FValue := FValue - Value;
     Result := Self;
end;

end.
