﻿(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IVATNumber                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TPTVATNumber                                             **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
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

unit RO.TPTVATNumber;

interface

uses
    RO.IValue
  , RO.IVATNumber
  ;

type
  TPTVATNumber = class(TInterfacedObject, IVATNumber)
  private
    FPTVATNumber: IString;
    FValid: IBoolean;
    function CalcCheckDigit: Integer;
  public
    constructor Create(const PTVATNumber: string);
    class function New(const PTVATNumber: string): IVATNumber; overload;
    class function New(const PTVATNumber: IString): IVATNumber; overload;
    class function New(const PTVATNumber: IInteger): IVATNumber; overload;
    function IsValid: Boolean;
    function AsString: string;
  end;

implementation

uses
    SysUtils
  , RegularExpressions
  , StrUtils
  , RO.TValue
  {$IF CompilerVersion <= 24.0}
  , RO.Helpers
  {$ENDIF}
  ;

{ TPTVATNumber }

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

function TPTVATNumber.AsString: string;
begin
  Result := FPTVATNumber.Value;
end;

constructor TPTVATNumber.Create(const PTVATNumber: string);
begin
  FValid := TBoolean.New(
    function: Boolean
    begin
      Result := TRegEx.IsMatch(FPTVATNumber.Value, '^(?!\s*$)[0-9]{9}$')
        and (RightStr(FPTVATNumber.Value, 1).ToInteger = CalcCheckDigit);
    end
  );
  FPTVATNumber := TString.New(
    function: string
    begin
      Result := StringReplace(PTVATNumber, ' ', '', [rfReplaceAll]);
    end
  );
end;

function TPTVATNumber.IsValid: Boolean;
begin
  Result := FValid.Value;
end;

class function TPTVATNumber.New(const PTVATNumber: IInteger): IVATNumber;
begin
  Result := New(PTVATNumber.Value.ToString);
end;

class function TPTVATNumber.New(const PTVATNumber: string): IVatNumber;
begin
  Result := Create(PTVATNumber);
end;

class function TPTVATNumber.New(const PTVATNumber: IString): IVATNumber;
begin
  Result := New(PTVATNumber.Value);
end;

end.
