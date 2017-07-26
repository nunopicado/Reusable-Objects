(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPTVATNumber                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPTVATNumber                                             **)
(** Classes       : TPTVATNumber, Implements IPTVATNumber                    **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Validates a string to be a valid Portuguese VAT Number   **)
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

unit Obj.SSI.TPTVATNumber;

interface

uses
    Obj.SSI.IValue
  , Obj.SSI.IPTVATNumber
  ;

type
  TPTVATNumber = class(TInterfacedObject, IPTVATNumber)
  private
    FPTVATNumber: IString;
    function CalcCheckDigit: Integer;
  public
    constructor Create(PTVATNumber: IString);
    class function New(PTVATNumber: IString): IPTVATNumber; overload;
    class function New(PTVATNumber: string): IPTVatNumber; overload;
    function IsValid: Boolean;
    function AsIString: IString;
    function AsIInteger: IInteger;
  end;

implementation

uses
    SysUtils
  , RegularExpressions
  , StrUtils
  , Obj.SSI.Helpers
  , Obj.SSI.TPrimitive
  ;

{ TPTVATNumber }

function TPTVATNumber.AsIInteger: IInteger;
begin
  if IsValid
    then Result := TInteger.New(
      FPTVATNumber.Value.ToInteger
    );
end;

function TPTVATNumber.CalcCheckDigit: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Pred(FPTVATNumber.Value.Length) do
      Inc(Result, (10 - i) * Copy(FPTVATNumber.Value, i, 1).ToInteger);
  Result := 11 - (Result mod 11);
  if Result >= 10
     then Result := 0;
end;

function TPTVATNumber.AsIString: IString;
begin
  Result := FPTVATNumber;
end;

constructor TPTVATNumber.Create(PTVATNumber: IString);
begin
  FPTVATNumber := PTVATNumber;
end;

function TPTVATNumber.IsValid: Boolean;
begin
  Result := TRegEx.IsMatch(FPTVATNumber.Value, '^(?!\s*$)[0-9]{9}$') and
            (RightStr(FPTVATNumber.Value, 1).ToInteger = CalcCheckDigit);
end;

class function TPTVATNumber.New(PTVATNumber: string): IPTVatNumber;
begin
  Result := New(
    TString.New(
      PTVATNumber
    )
  );
end;

class function TPTVATNumber.New(PTVATNumber: IString): IPTVATNumber;
begin
  Result := New(StringReplace(PTVATNumber.Value, ' ', '', [rfReplaceAll]));
end;

end.
