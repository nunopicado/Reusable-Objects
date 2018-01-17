(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    : TNextAlphaNumber                                         **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Returns the next 'number' in an alphabetic numbering     **)
(**                 system based on A-Z values                               **)
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

unit RO.TNextAlphaNumber;

interface

uses
    RO.IValue
  , RO.TString
  ;

type
  TNextAlphaNumber = class(TDecorableIString, IString)
  private
    FValue: IString;
  public
    constructor Create(const Origin: IString); reintroduce;
    class function New(const Origin: IString): IString; reintroduce;
    function Value: string; override;
  end;

implementation

uses
    RO.TValue
  , SysUtils
  ;

{ TAlphaNumbering }

constructor TNextAlphaNumber.Create(const Origin: IString);
begin
  FValue := TString.New(
    function : string
    var
      Digit: Integer;
    begin
      Result := Trim(UpperCase(Origin.Value));
      Digit  := Result.Length;
      repeat
        if Result[Digit] < 'Z'
          then begin
            Inc(Result[Digit]);
            Digit := 0;
          end
          else begin
            Result[Digit] := 'A';
            if Digit > 1
              then Dec(Digit)
              else begin
                Result := Result + 'A';
                Digit  := 0;
              end;
          end;
      until Digit = 0;
      Result := Trim(Result);
    end
  );
end;

class function TNextAlphaNumber.New(const Origin: IString): IString;
begin
  Result := Create(Origin);
end;

function TNextAlphaNumber.Value: string;
begin
  Result := FValue.Value;
end;

end.
