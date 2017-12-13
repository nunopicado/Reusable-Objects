(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICSVString                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TCSVString                                               **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Extracts fields from a comma delimited string            **)
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

unit RO.TCSVString;

interface

uses
    RO.ICSVString
  , RO.IValue
  ;

type
  TCSVString = class(TInterfacedObject, ICSVString)
  private const
    cDefaultDelimiter = ';';
  private var
    FCSV: string;
    FDelimiter: Char;
    FCount: IByte;
  public
    constructor Create(const CSVString: string; const Delimiter: Char); overload;
    constructor Create(const CSVString: string); overload;
    class function New(const CSVString: string; const Delimiter: Char): ICSVString; overload;
    class function New(const CSVString: string): ICSVString; overload;
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

constructor TCSVString.Create(const CSVString: string);
begin
  Create(CSVString, cDefaultDelimiter);
end;

function TCSVString.Field(const FieldNumber: Byte;
  const Default: string): string;
var
  i: Byte;
begin
  Result := FCSV;
  for i := 1 to Pred(FieldNumber) do
    Delete(Result, 1, Pos(FDelimiter, Result));
  Delete(Result, Pos(FDelimiter, Result), Result.Length);
  if Result.IsEmpty and not Default.IsEmpty
    then Result := Default;
end;

class function TCSVString.New(const CSVString: string): ICSVString;
begin
  Result := New(CSVString, cDefaultDelimiter);
end;

class function TCSVString.New(const CSVString: string;
  const Delimiter: Char): ICSVString;
begin
  Result := Create(CSVString, Delimiter);
end;

end.
