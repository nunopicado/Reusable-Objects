(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IString                                                  **)
(** Classes       : TNumbersOnly, decorates IString to strip all non-numeric **)
(**                 TGroupDigits, decorates IString to group characters in   **)
(**                   groups of certain size                                 **)
(**                 TCut, decorates IString to copy only the left most       **)
(**                   substring of a certain size                            **)
(**                 TDefault, decorates IString to return a default value    **)
(**                   in case the main IString is empty                      **)
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

unit RO.TString;

interface

uses
    RO.IValue
  ;

type
  {$M+}
  TDecorableIString = class(TInterfacedObject, IString)
  protected
    FOrigin: IString;
  public
    constructor Create(Origin: IString); virtual;
    class function New(Origin: IString): IString; virtual;
    function Value: string; virtual;
    function Refresh: IString; virtual;
  end;

  TNumbersOnly = class(TDecorableIString, IString)
  private
    FValue: IString;
  public
    constructor Create(Origin: IString); override;
    class function New(Origin: IString): IString; override;
    function Value: string; override;
  end;

  TGroupDigits = class(TDecorableIString, IString)
  private
    FDigitsPerGroup: Byte;
    FValue: IString;
  public
    constructor Create(Origin: IString; DigitsPerGroup: Byte); reintroduce;
    class function New(Origin: IString; DigitsPerGroup: Byte): IString; reintroduce;
    function Value: string; override;
  end;

  TCut = class(TDecorableIString, IString)
  private
    FCharacters: Integer;
    FValue: IString;
  public
    constructor Create(Origin: IString; Characters: Integer); reintroduce;
    class function New(Origin: IString; Characters: Integer): IString; reintroduce;
    function Value: string; override;
  end;

  TDefault = class(TDecorableIString, IString)
  private
    FDefault: IString;
  public
    constructor Create(Origin: IString; Default: IString); reintroduce;
    class function New(Origin: IString; Default: IString): IString; reintroduce;
    function Value: string; override;
  end;
  {$M-}

implementation

uses
    SysUtils
  , RO.IIf
  , RO.TIf
  , RO.TValue
  ;

{ TNumbersOnlyString }

function TNumbersOnly.Value: string;
begin
  Result := FValue.Value;
end;

constructor TNumbersOnly.Create(Origin: IString);
begin
  FOrigin := Origin;
  FValue  := TString.New(
    function : string
    var
      i: Integer;
    begin
      Result := FOrigin.Value;
      for i := Result.Length downto 1 do
        if not CharInSet(Result[i], ['0'..'9'])
          then Delete(Result, i, 1);
    end
  );
end;

class function TNumbersOnly.New(Origin: IString): IString;
begin
  Result := Create(Origin);
end;

{ TGroupDigits }

function TGroupDigits.Value: string;
begin
  Result := FValue.Value;
end;

constructor TGroupDigits.Create(Origin: IString; DigitsPerGroup: Byte);
begin
  FOrigin         := Origin;
  FDigitsPerGroup := DigitsPerGroup;
  FValue          := TString.New(
    function : string
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
    end
  );
end;

class function TGroupDigits.New(Origin: IString; DigitsPerGroup: Byte): IString;
begin
  Result := Create(Origin, DigitsPerGroup);
end;

{ TCut }

function TCut.Value: string;
begin
  Result := FValue.Value;
end;

constructor TCut.Create(Origin: IString; Characters: Integer);
begin
  FOrigin     := Origin;
  FCharacters := Characters;
  FValue      := TString.New(
    function : string
    begin
      Result := Copy(FOrigin.Value, 1, FCharacters);
    end
  );
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

{ TDecorableIString }

constructor TDecorableIString.Create(Origin: IString);
begin
  FOrigin := Origin;
end;

class function TDecorableIString.New(Origin: IString): IString;
begin
  Result := Create(Origin);
end;

function TDecorableIString.Refresh: IString;
begin
  Result := Self;
  FOrigin.Refresh;
end;

function TDecorableIString.Value: string;
begin
  Result := FOrigin.Value;
end;

end.
