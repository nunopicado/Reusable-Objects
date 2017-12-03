(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IStringMask                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TStringMask                                              **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : A Mask to apply to any string and parse it accordingly   **)
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

unit RO.TStringMask;

interface

uses
    RO.IStringMask
  , RO.IValue
  ;

type
  TStringMask = class(TInterfacedObject, IStringMask)
  private const
    cAcceptedChars = '#Y*+';
  private var
    FMask: string;
  public
    constructor Create(const Mask: string);
    class function New(const Mask: string): IStringMask; overload;
    class function New(const Mask: IString): IStringMask; overload;
    function Parse(const Str: string): string;
  end;

implementation

uses
    RO.TValue
  , Math
  , SysUtils
  ;

{ TStringMask }

constructor TStringMask.Create(const Mask: string);
begin
  FMask := Mask;
end;

class function TStringMask.New(const Mask: string): IStringMask;
begin
  Result := Create(Mask);
end;

class function TStringMask.New(const Mask: IString): IStringMask;
begin
  Result := New(Mask.Value);
end;

function TStringMask.Parse(const Str: string): string;
var
  i: Byte;
begin
  Result := '';
  for i := 1 to Min(Str.Length, FMask.Length) do
    if pos(UpCase(FMask[i]), cAcceptedChars) > 0
      then Result := Result + Str[i];
end;

end.
