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
     if Result.Length<FNewSize
        then begin
                  PadString := StringOfChar(FPadChar, FNewSize-Result.Length);
                  case FPadSide of
                       psLeft  : Result := PadString + Result;
                       psRight : Result := Result + PadString;
                  end;
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

end.
