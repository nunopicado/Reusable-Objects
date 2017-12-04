unit RO.TCSVString;

interface

uses
    RO.ICSVString
  , RO.IValue
  ;

type
  TCSVString = class(TInterfacedObject, ICSVString)
  private
    FCSV: string;
    FDelimiter: Char;
    FCount: IByte;
  public
    constructor Create(const CSVString: string; const Delimiter: Char);
    class function New(const CSVString: string; const Delimiter: Char): ICSVString;
    function Count: Byte;
    function Field(const FieldNumber: Byte; const Default: string = ''): string;
  end;

implementation

uses
    RO.TValue
  , SysUtils
  , StrUtils
  ;

{ TCSVString }

function TCSVString.Count: Byte;
begin
  Result := FCount.Value;
end;

constructor TCSVString.Create(const CSVString: string; const Delimiter: Char);
begin
  FCSV       := CSVString + Delimiter;
  FDelimiter := Delimiter;
  FCount     := TByte.New(
    function : Byte
    var
      i: Byte;
    begin
      Result := 0;
      for i := 1 to FCSV.Length do
        if FCSV[i] = FDelimiter
          then Inc(Result);
    end
  );
end;

function TCSVString.Field(const FieldNumber: Byte;
  const Default: string): string;
var
  i     : Byte;
begin
  Result := FCSV;
  for i := 1 to Pred(FieldNumber) do
    Delete(Result, 1, Pos(FDelimiter, Result));
  Delete(Result, Pos(FDelimiter, Result), Result.Length);
  if Result.IsEmpty and not Default.IsEmpty
    then Result := Default;
end;

class function TCSVString.New(const CSVString: string;
  const Delimiter: Char): ICSVString;
begin
  Result := Create(CSVString, Delimiter);
end;

end.
