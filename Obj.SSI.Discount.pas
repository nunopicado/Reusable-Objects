(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDiscount                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IDiscount                                                **)
(** Classes       : TDiscount, implements IDiscount                          **)
(******************************************************************************)
(** Dependencies  : ICurrency                                                **)
(**               : RTL                                                      **)
(******************************************************************************)
(** Description   : Applies discount actions to ICurrency values             **)
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
