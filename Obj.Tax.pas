unit Obj.Tax;

interface

uses
    Obj.Currency;

type
    ITax = Interface                  ['{C5E0F3F9-8804-46FD-B03F-D75DE3EC1EB2}']
      function AsCurrency: Currency;
      function AsICurrency: ICurrency;
      function AsString: String;
      function Add(TaxPercentage: Single): ITax;
      function Sub(TaxPercentage: Single): ITax;
      function AddValue(TaxValue: Currency): ITax;
      function SubValue(TaxValue: Currency): ITax;
    End;

    TTax = Class(TInterfacedObject, ITax)
    private
      FValue: Currency;
      constructor Create(BaseValue: Currency); Overload;
    public
      class function New(BaseValue: Currency): ITax;
      function AsCurrency: Currency;
      function AsICurrency: ICurrency;
      function AsString: String;
      function Add(TaxPercentage: Single): ITax;
      function Sub(TaxPercentage: Single): ITax;
      function AddValue(TaxValue: Currency): ITax;
      function SubValue(TaxValue: Currency): ITax;
    End;

implementation

{ TTax }

function TTax.AddValue(TaxValue: Currency): ITax;
begin
     FValue := FValue + TaxValue;
     Result := Self;
end;

function TTax.AsCurrency: Currency;
begin
     Result := FValue;
end;

function TTax.AsICurrency: ICurrency;
begin
     Result := TCurrency.New(FValue);
end;

function TTax.AsString: String;
begin
     Result := AsICurrency.AsString;
end;

constructor TTax.Create(BaseValue: Currency);
begin
     inherited Create;
     FValue := BaseValue;
end;

class function TTax.New(BaseValue: Currency): ITax;
begin
     Result := Create(BaseValue);
end;

function TTax.Add(TaxPercentage: Single): ITax;
begin
     FValue := FValue * (1 + TaxPercentage / 100);
     Result := Self;
end;

function TTax.Sub(TaxPercentage: Single): ITax;
begin
     FValue := FValue / (1 + TaxPercentage / 100);
     Result := Self;
end;

function TTax.SubValue(TaxValue: Currency): ITax;
begin
     FValue := FValue - TaxValue;
     Result := Self;
end;

end.
