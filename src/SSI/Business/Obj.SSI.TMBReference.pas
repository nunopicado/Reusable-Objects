(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMBReference                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMBReference                                             **)
(** Classes       : TMbRef, implements IMBReference, lazy validation         **)
(**               :  assumes all inputs in the correct format                **)
(**                 TMBRefFactory, creates an MBRef, returned as IString,    **)
(**                  handling input preparation and validation               **)
(**                 TNumbersOnly, decorates IString to strip all non-numeric **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Generates MB (Portuguese ATM) payment references         **)
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

unit Obj.SSI.TMBReference;

interface

uses
    Obj.SSI.IValue
  , Obj.SSI.IBMReference
  ;

type
  TMBReference = class(TInterfacedObject, IMBReference)
  private
    FEntity: Integer;
    FID: Int64;
    FValue: Currency;
    FReference: IValue<IString>;
    function DoCalc: IString;
  public
    constructor Create(const Entity: Integer; const ID: Int64; const Value: Currency);
    class function New(const Entity: Integer; const ID: Int64; const Value: Currency): IMBReference;
    function AsIString: IString;
  end;

implementation

uses
    SysUtils
  , Obj.SSI.TPrimitive
  , Obj.SSI.TString
  , Obj.SSI.TCached
  ;

{ TMBReference }

constructor TMBReference.Create(const Entity: Integer; const ID: Int64; const Value: Currency);
begin
  FEntity    := Entity;
  FID        := ID;
  FValue     := Value;
  FReference :=
  TCached<IString>.New(
    DoCalc
  );
end;

function TMBReference.DoCalc: IString;
var
  Value : Integer;
  Ch    : Char;
begin
  Value := 0;
  for Ch in (FEntity.ToString.PadLeft(5, '0') + FID.ToString.PadLeft(7, '0') + FloatToStrF(FValue * 100, ffGeneral, 8, 0).PadLeft(8, '0')) do
    Value := ((Value + StrToInt(Ch)) * 10) mod 97;
  Value  := 98 - ((Value * 10) mod 97);
  Result := TString.New(
    FID.ToString + Value.ToString.PadLeft(2, '0')
  );
end;

class function TMBReference.New(const Entity: Integer; const ID: Int64; const Value: Currency): IMBReference;
begin
  Result := Create(Entity, ID, Value);
end;

function TMBReference.AsIString: IString;
begin
  Result := FReference.Value;
end;

end.
