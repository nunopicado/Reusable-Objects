unit Obj.SSI.Discount;

interface

uses
    Obj.SSI.Currency;

type
    IDiscount = Interface             ['{CB98B202-D9F2-48B0-8376-F3144336C56F}']
      function AsCurrency: Currency;
      function AsICurrency: ICurrency;
      function AsString: String;
      function Add(DiscountPercentage: Single): IDiscount;
      function Sub(DiscountPercentage: Single): IDiscount;
      function AddValue(DiscountValue: Currency): IDiscount;
      function SubValue(DiscountValue: Currency): IDiscount;
    End;

    TDiscount = Class(TInterfacedObject, IDiscount)
    private
      FValue: Currency;
      constructor Create(BaseValue: Currency); Overload;
      function CalcDiscount(DiscountPercentage: Single): Currency;
    public
      class function New(BaseValue: Currency): IDiscount;
      function AsCurrency: Currency;
      function AsICurrency: ICurrency;
      function AsString: String;
      function Add(DiscountPercentage: Single): IDiscount;
      function Sub(DiscountPercentage: Single): IDiscount;
      function AddValue(DiscountValue: Currency): IDiscount;
      function SubValue(DiscountValue: Currency): IDiscount;
    End;

implementation

{ TDiscount }

function TDiscount.AddValue(DiscountValue: Currency): IDiscount;
begin
     FValue := FValue + DiscountValue;
     Result := Self;
end;

function TDiscount.AsCurrency: Currency;
begin
     Result := FValue;
end;

function TDiscount.AsICurrency: ICurrency;
begin
     Result := TCurrency.New(FValue);
end;

function TDiscount.AsString: String;
begin
     Result := AsICurrency.AsString;
end;

function TDiscount.CalcDiscount(DiscountPercentage: Single): Currency;
begin
     Result := FValue * (DiscountPercentage/100);
end;

constructor TDiscount.Create(BaseValue: Currency);
begin
     inherited Create;
     FValue := BaseValue;
end;

class function TDiscount.New(BaseValue: Currency): IDiscount;
begin
     Result := Create(BaseValue);
end;

function TDiscount.Add(DiscountPercentage: Single): IDiscount;
begin
     FValue := FValue + CalcDiscount(DiscountPercentage);
     Result := Self;
end;

function TDiscount.Sub(DiscountPercentage: Single): IDiscount;
begin
     FValue := FValue - CalcDiscount(DiscountPercentage);
     Result := Self;
end;

function TDiscount.SubValue(DiscountValue: Currency): IDiscount;
begin
     FValue := FValue - DiscountValue;
     Result := Self;
end;

end.
