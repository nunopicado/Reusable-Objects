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

unit Obj.SSI.IPTVATNumber;

interface

type
    IPTVATNumber = Interface
      function IsValid: Boolean;
      function AsString: String;
      function AsInteger: Integer;
    End;

    TPTVATNumber = Class(TInterfacedObject, IPTVATNumber)
    private
      FPTVATNumber: String;
      constructor Create(PTVATNumber: String);
      function CalcCheckDigit: Integer;
    public
      class function New(PTVATNumber: String): IPTVATNumber;
      function IsValid: Boolean;
      function AsString: String;
      function AsInteger: Integer;
    End;

implementation

uses
    SysUtils
  , RegularExpressions
  , StrUtils
  ;

{ TPTVATNumber }

function TPTVATNumber.AsInteger: Integer;
begin
     if IsValid
        then Result := FPTVATNumber.ToInteger;
end;

function TPTVATNumber.CalcCheckDigit: Integer;
var
   i: Integer;
begin
     Result := 0;
     for i := 1 to Pred(FPTVATNumber.Length) do
         Inc(Result, (10 - i) * Copy(FPTVATNumber, i, 1).ToInteger);
     Result := 11 - (Result mod 11);
     if Result >= 10
        then Result := 0;
end;

function TPTVATNumber.AsString: String;
begin
     Result := FPTVATNumber;
end;

constructor TPTVATNumber.Create(PTVATNumber: String);
begin
     FPTVATNumber := PTVATNumber;
end;

function TPTVATNumber.IsValid: Boolean;
begin
     Result := TRegEx.IsMatch(FPTVATNumber, '^(?!\s*$)[0-9]{9}$') and
               (RightStr(FPTVATNumber, 1).ToInteger = CalcCheckDigit);
end;

class function TPTVATNumber.New(PTVATNumber: String): IPTVATNumber;
begin
     Result := Create(PTVATNumber);
end;

end.
