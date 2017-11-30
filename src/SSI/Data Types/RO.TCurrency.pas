(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICurrency                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
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

unit RO.TCurrency;

interface

uses
    RO.ICurrency
  ;

type
  TDecorableCurrency = class(TInterfacedObject, ICurrency)
  protected
    FOrigin: ICurrency;
  public
    function Value: Currency; virtual;
    function AsString: string; virtual;
    function Add(const Value: Currency): ICurrency; virtual;
    function Sub(const Value: Currency): ICurrency; virtual;
    function Reset: ICurrency; virtual;
  end;

  TCurrency = class(TInterfacedObject, ICurrency)
  private
    FValue: Currency;
    constructor Create(const InitialValue: Currency);
  public
    class function New(const InitialValue: Currency): ICurrency;
    function Value: Currency;
    function AsString: string;
    function Add(const Value: Currency): ICurrency;
    function Sub(const Value: Currency): ICurrency;
    function Reset: ICurrency;
  end;

  TDiscount = class(TDecorableCurrency, ICurrency)
  private
    constructor Create(const Origin: ICurrency; const Discount: Single);
  public
    class function New(const Origin: ICurrency; const Discount: Single): ICurrency;
  end;

  TTax = Class(TDecorableCurrency, ICurrency)
  private
    constructor Create(const Origin: ICurrency; const Tax: Single);
    function CalcTax(const BaseValue: Currency; const Tax: Single): Currency;
  public
    class function New(const Origin: ICurrency; const Tax: Single): ICurrency;
  end;

implementation

uses
    SysUtils
  ;

{ TCurrency }

function TCurrency.Add(const Value: Currency): ICurrency;
begin
  Result := New(FValue + Value);
end;

function TCurrency.Value: Currency;
begin
  Result := FValue;
end;

function TCurrency.AsString: string;
begin
  Result := CurrToStrF(FValue, ffCurrency, FormatSettings.CurrencyDecimals);
end;

constructor TCurrency.Create(const InitialValue: Currency);
begin
  inherited Create;
  FValue := InitialValue;
end;

class function TCurrency.New(const InitialValue: Currency): ICurrency;
begin
  Result := Create(InitialValue);
end;

function TCurrency.Reset: ICurrency;
begin
  Result := New(0);
end;

function TCurrency.Sub(const Value: Currency): ICurrency;
begin
  Result := New(FValue - Value);
end;

{ TDecorableCurrency }

function TDecorableCurrency.Add(const Value: Currency): ICurrency;
begin
  Result := Self;
  FOrigin.Add(Value);
end;

function TDecorableCurrency.AsString: string;
begin
  Result := FOrigin.AsString;
end;

function TDecorableCurrency.Reset: ICurrency;
begin
  Result := Self;
  FOrigin.Reset;
end;

function TDecorableCurrency.Sub(const Value: Currency): ICurrency;
begin
  Result := Self;
  FOrigin.Sub(Value);
end;

function TDecorableCurrency.Value: Currency;
begin
  Result := FOrigin.Value;
end;

{ TDiscount }

constructor TDiscount.Create(const Origin: ICurrency; const Discount: Single);
begin
  FOrigin := Origin.Sub(Origin.Value * (Discount/100));
end;

class function TDiscount.New(const Origin: ICurrency; const Discount: Single): ICurrency;
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

constructor TTax.Create(const Origin: ICurrency; const Tax: Single);
begin
  FOrigin := Origin.Reset.Add(CalcTax(Origin.Value, Tax));
end;

class function TTax.New(const Origin: ICurrency; const Tax: Single): ICurrency;
begin
  Result := Create(Origin, Tax);
end;

end.
