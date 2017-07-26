(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IString                                                  **)
(** Classes       : TString, implements IString                              **)
(**                 TPadded, decorates IString to pad it to a new size       **)
(**                 TNumbersOnly, decorates IString to strip all non-numeric **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Handles immutable strings with optional decorations      **)
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

unit Obj.SSI.TString;

interface

uses
    Obj.SSI.IPrimitive
  ;

type
  {$M+}
  TNumbersOnly = class(TInterfacedObject, IString)
  private
    FOrigin: IString;
  public
    constructor Create(Origin: IString);
    class function New(Origin: IString): IString;
    function Value: string;
  end;

  TGroupDigits = class(TInterfacedObject, IString)
  private
    FOrigin: IString;
    FDigitsPerGroup: Byte;
  public
    constructor Create(Origin: IString; DigitsPerGroup: Byte);
    class function New(Origin: IString; DigitsPerGroup: Byte): IString;
    function Value: string;
  end;

  TCut = class(TInterfacedObject, IString)
  private
    FOrigin: IString;
    FCharacters: Integer;
  public
    constructor Create(Origin: IString; Characters: Integer);
    class function New(Origin: IString; Characters: Integer): IString;
    function Value: string;
  end;

  TDefault = class(TInterfacedObject, IString)
  private
    FOrigin: IString;
    FDefault: IString;
  public
    constructor Create(Origin: IString; Default: IString);
    class function New(Origin: IString; Default: IString): IString;
    function Value: string;
  end;
  {$M-}

implementation

uses
    SysUtils
  , Obj.SSI.IIf
  , Obj.SSI.TIf
  ;

{ TNumbersOnlyString }

function TNumbersOnly.Value: string;
var
  i: Integer;
begin
  Result := FOrigin.Value;
  for i := Result.Length downto 1 do
    if not CharInSet(Result[i], ['0'..'9'])
      then Delete(Result, i, 1);
end;

constructor TNumbersOnly.Create(Origin: IString);
begin
  FOrigin := Origin;
end;

class function TNumbersOnly.New(Origin: IString): IString;
begin
  Result := Create(Origin);
end;

{ TGroupDigits }

function TGroupDigits.Value: string;
var
  i: Integer;
begin
  Result := FOrigin.Value;
  i := Result.Length - FDigitsPerGroup;
  while i > 0 do
    begin
      Result.Insert(i, ' ');
      Dec(i, FDigitsPerGroup);
    end;
end;

constructor TGroupDigits.Create(Origin: IString; DigitsPerGroup: Byte);
begin
  FOrigin         := Origin;
  FDigitsPerGroup := DigitsPerGroup;
end;

class function TGroupDigits.New(Origin: IString; DigitsPerGroup: Byte): IString;
begin
  Result := Create(Origin, DigitsPerGroup);
end;

{ TCut }

function TCut.Value: string;
begin
  Result := Copy(FOrigin.Value, 1, FCharacters);
end;

constructor TCut.Create(Origin: IString; Characters: Integer);
begin
  FOrigin     := Origin;
  FCharacters := Characters;
end;

class function TCut.New(Origin: IString; Characters: Integer): IString;
begin
  Result := Create(Origin, Characters);
end;

{ TDefault }

function TDefault.Value: string;
begin
  Result := TIf<string>.New(
    FOrigin.Value.IsEmpty,
    FDefault.Value,
    FOrigin.Value
  ).Eval;
end;

constructor TDefault.Create(Origin: IString; Default: IString);
begin
  FOrigin  := Origin;
  FDefault := Default;
end;

class function TDefault.New(Origin: IString; Default: IString): IString;
begin
  Result := Create(Origin, Default);
end;

end.
