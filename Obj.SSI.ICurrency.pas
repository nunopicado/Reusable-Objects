(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICurrency                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICurrency                                                **)
(** Classes       : TCurrency, implements ICurrency                          **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles Currency values and calculations                 **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**                 terms                                                    **)
(******************************************************************************)

unit Obj.SSI.ICurrency;

interface

type
    ICurrency = Interface             ['{EF61CB53-7281-4645-B3C5-C5EE860FC2C5}']
      function Value: Currency;
      function AsString: String;
      function Add(Value: Currency): ICurrency;
      function Sub(Value: Currency): ICurrency;
      function Reset: ICurrency;
    End;

    TDecorableCurrency = Class(TInterfacedObject, ICurrency)
    protected
      FOrigin: ICurrency;
    public
      function Value: Currency;
      function AsString: String;
      function Add(Value: Currency): ICurrency;
      function Sub(Value: Currency): ICurrency;
      function Reset: ICurrency;
    End;

    TCurrency = Class(TInterfacedObject, ICurrency)
    private
      FValue: Currency;
      constructor Create(InitialValue: Currency);
    public
      class function New(InitialValue: Currency): ICurrency;
      function Value: Currency;
      function AsString: String;
      function Add(Value: Currency): ICurrency;
      function Sub(Value: Currency): ICurrency;
      function Reset: ICurrency;
    End;

    TDiscount = Class(TDecorableCurrency, ICurrency)
    private
      constructor Create(Origin: ICurrency; const Discount: Single);
    public
      class function New(Origin: ICurrency; const Discount: Single): ICurrency;
    End;

    TTax = Class(TDecorableCurrency, ICurrency)
    private
      constructor Create(Origin: ICurrency; const Tax: Single);
      function CalcTax(const BaseValue: Currency; const Tax: Single): Currency;
    public
      class function New(Origin: ICurrency; const Tax: Single): ICurrency;
    End;

implementation

uses
    SysUtils
  , Obj.SSI.IIF
  ;


{ TCurrency }

function TCurrency.Add(Value: Currency): ICurrency;
begin
     Result := New(FValue + Value);
end;

function TCurrency.Value: Currency;
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
     Result := New(0);
end;

function TCurrency.Sub(Value: Currency): ICurrency;
begin
     Result := New(FValue - Value);
end;

{ TDecorableCurrency }

function TDecorableCurrency.Add(Value: Currency): ICurrency;
begin
     Result := FOrigin.Add(Value);
end;

function TDecorableCurrency.AsString: String;
begin
     Result := FOrigin.AsString;
end;

function TDecorableCurrency.Reset: ICurrency;
begin
     Result := FOrigin.Reset;
end;

function TDecorableCurrency.Sub(Value: Currency): ICurrency;
begin
     Result := FOrigin.Sub(Value);
end;

function TDecorableCurrency.Value: Currency;
begin
     Result := FOrigin.Value;
end;

{ TDiscount }

constructor TDiscount.Create(Origin: ICurrency; const Discount: Single);
begin
     FOrigin := Origin.Sub(Origin.Value * (Discount/100));
end;

class function TDiscount.New(Origin: ICurrency; const Discount: Single): ICurrency;
begin
     Result := Create(Origin, Discount);
end;

{ TTax }

function TTax.CalcTax(const BaseValue: Currency; const Tax: Single): Currency;
var
   Control: Single;
begin
     Control := 1 + Abs(Tax) / 100;
     if Tax >= 0
        then Result := BaseValue * Control
        else Result := BaseValue / Control;
end;

constructor TTax.Create(Origin: ICurrency; const Tax: Single);
begin
     FOrigin := Origin.Reset.Add(CalcTax(Origin.Value, Tax));
end;

class function TTax.New(Origin: ICurrency; const Tax: Single): ICurrency;
begin
     Result := Create(Origin, Tax);
end;

end.
