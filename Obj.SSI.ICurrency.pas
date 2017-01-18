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

    TCurrency = Class(TInterfacedObject, ICurrency)
    private
      FValue: Currency;
      constructor Create(InitialValue: Currency); Overload;
    public
      class function New(InitialValue: Currency): ICurrency;
      function Value: Currency;
      function AsString: String;
      function Add(Value: Currency): ICurrency;
      function Sub(Value: Currency): ICurrency;
      function Reset: ICurrency;
    End;

    TDiscount = Class(TInterfacedObject, ICurrency)
    private
      FOrigin   : ICurrency;
      constructor Create(Origin: ICurrency; const Discount: Single);
    public
      class function New(Origin: ICurrency; const Discount: Single): ICurrency;
      function Value: Currency;
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

{ TDiscount }

function TDiscount.Add(Value: Currency): ICurrency;
begin
     Result := FOrigin.Add(Value);
end;

function TDiscount.AsString: String;
begin
     Result := FOrigin.AsString;
end;

constructor TDiscount.Create(Origin: ICurrency; const Discount: Single);
begin
     FOrigin := Origin.Sub(Origin.Value * (Discount/100));
end;

class function TDiscount.New(Origin: ICurrency; const Discount: Single): ICurrency;
begin
     Result := Create(Origin, Discount);
end;

function TDiscount.Reset: ICurrency;
begin
     Result := FOrigin.Reset;
end;

function TDiscount.Sub(Value: Currency): ICurrency;
begin
     Result := FOrigin.Sub(Value);
end;

function TDiscount.Value: Currency;
begin
     Result := FOrigin.Value;
end;

end.
