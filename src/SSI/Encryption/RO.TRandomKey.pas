(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TRandomKey                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IRandomKey                                               **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Generates a ransom key with a determined number of bits  **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit RO.TRandomKey;

interface

uses
    RO.IRandomKey
  , RO.IValue
  ;

type
  TRandomKey = class(TInterfacedObject, IRandomKey)
  private
    FKey: IString;
    FKeySize: Byte;
    function Generate: string;
  public
    constructor Create(const KeySize: Byte);
    class function New(const KeySize: Byte = 16): IRandomKey;
    function AsString: string;
  end;

implementation

uses
    SysUtils
  , StrUtils
  , RO.TValue
  , Windows
  ;

function TRandomKey.AsString: string;
begin
  Result := FKey.Value;
end;

constructor TRandomKey.Create(const KeySize: Byte);
begin
  FKeySize := KeySize;
  FKey     := TString.NewDelayed(Generate);
end;

function TRandomKey.Generate: string;
type
  TStringArray = array [1..6] of string;
var
  i, j: Byte;
  v: NativeInt;
  s: TStringArray;
begin
  Randomize;

  Result := '';
  s      := Default(TStringArray);
  for i := 1 to FKeySize do
    for j := Low(s) to High(s) do
      s[j] := s[j] + Random(9).ToString;
  for i := 1 to FKeySize do
    begin
      v := 0;
      for j := Low(s) to High(s) do
        Inc(v, StrToInt(s[j][i]));
      Result := Result + RightStr(v.ToString, 1);
    end;
end;

class function TRandomKey.New(const KeySize: Byte): IRandomKey;
begin
  Result := Create(KeySize);
end;

end.
