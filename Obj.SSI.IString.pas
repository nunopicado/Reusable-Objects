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

unit Obj.SSI.IString;

interface

type
    {$M+}
    IString = Interface ['{1D46A21E-616E-4E27-A1D8-C13FAB88009E}']
      function AsString: String;
    End;

    TString = Class (TInterfacedObject, IString)
    private
      FString: String;
    public
      constructor Create(aString: String);
      class function New(aString: String): IString;
      function AsString: String;
    End;

    TNumbersOnly = Class(TInterfacedObject, IString)
    private
      FOrigin: IString;
    public
      constructor Create(Origin: IString);
      class function New(Origin: IString): IString;
      function AsString: String;
    End;

    TPadSide = (psLeft, psRight);
    TPadded = Class(TInterfacedObject, IString)
    private
      FOrigin: IString;
      FNewSize: Integer;
      FPadChar: Char;
      FPadSide: TPadSide;
    public
      constructor Create(Origin: IString; NewSize: Integer; PadChar: Char = '0'; PadSide: TPadSide = psLeft);
      class function New(Origin: IString; NewSize: Integer; PadChar: Char = '0'; PadSide: TPadSide = psLeft): IString;
      function AsString: String;
    End;

    TGroupDigits = Class(TInterfacedObject, IString)
    private
      FOrigin: IString;
      FDigitsPerGroup: Byte;
    public
      constructor Create(Origin: IString; DigitsPerGroup: Byte);
      class function New(Origin: IString; DigitsPerGroup: Byte): IString;
      function AsString: String;
    End;

    TCut = Class(TInterfacedObject, IString)
    private
      FOrigin: IString;
      FCharacters: Integer;
    public
      constructor Create(Origin: IString; Characters: Integer);
      class function New(Origin: IString; Characters: Integer): IString;
      function AsString: String;
    End;

    TDefault = Class(TInterfacedObject, IString)
    private
      FOrigin: IString;
      FDefault: String;
    public
      constructor Create(Origin: IString; Default: String);
      class function New(Origin: IString; Default: String): IString;
      function AsString: String;
    End;
    {$M-}

implementation

uses
    SysUtils
  ;

{ TString }

function TString.AsString: String;
begin
     Result := FString;
end;

constructor TString.Create(aString: String);
begin
     FString := aString;
end;

class function TString.New(aString: String): IString;
begin
     Result := Create(aString);
end;

{ TNumbersOnlyString }

function TNumbersOnly.AsString: String;
var
   i: Integer;
begin
     Result := FOrigin.AsString;
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

{ TPaddedString }

function TPadded.AsString: String;
var
   PadString: String;
begin
     Result := Copy(FOrigin.AsString, 1, FNewSize);
     case FPadSide of
          psLeft  : Result := Result.PadLeft(FNewSize, FPadChar);
          psRight : Result := Result.PadRight(FNewSize, FPadChar);
     end;
end;

constructor TPadded.Create(Origin: IString; NewSize: Integer; PadChar: Char = '0'; PadSide: TPadSide = psLeft);
begin
     FOrigin  := Origin;
     FNewSize := NewSize;
     FPadChar := PadChar;
     FPadSide := PadSide;
end;

class function TPadded.New(Origin: IString; NewSize: Integer; PadChar: Char = '0'; PadSide: TPadSide = psLeft): IString;
begin
     Result := Create(Origin, NewSize, PadChar, PadSide);
end;

{ TGroupDigits }

function TGroupDigits.AsString: String;
var
  i: Integer;
begin
     Result := FOrigin.AsString;
     for i := Result.Length downto 1 do
         if (i mod 3 = 1) and (i<Result.Length)
            then Result.Insert(i, ' ');
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

function TCut.AsString: String;
begin
     Result := Copy(FOrigin.AsString, 1, FCharacters);
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

function TDefault.AsString: String;
begin
     if FOrigin.AsString.IsEmpty
        then Result := FDefault
        else Result := FOrigin.AsString;
end;

constructor TDefault.Create(Origin: IString; Default: String);
begin
     FOrigin  := Origin;
     FDefault := Default;
end;

class function TDefault.New(Origin: IString; Default: String): IString;
begin
     Result := Create(Origin, Default);
end;

end.
