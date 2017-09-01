(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IStringStat                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TStringStat, implements IStringStat                      **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : An object that returns some stats and functionality for  **)
(**                 strings                                                  **)
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

unit Obj.SSI.TStringStat;

interface

uses
    Obj.SSI.IStringStat
  ;

type
  TStringStat = class(TInterfacedObject, IStringStat)
  private
    FString: string;
  public
    constructor Create(const aString: string);
    class function New(const aString: string): IStringStat;
    function OccurrenciesOf(const Ch: Char): Word;
    function ciPos(const SubStr: string): Word;
    function Compare(const OtherString: string): Byte;
    function AdvSearch(SearchTerms: string): Boolean;
    function ContainsOnly(const CharList: TCharSet): Boolean;
  end;

implementation

uses
    SysUtils
  , StrUtils
  , Math
  , Classes
  ;

{ TStringStat }

function TStringStat.AdvSearch(SearchTerms: string): Boolean;
// & delimiter = OR search
// % delimiter = AND search
  function PrepareSearchTerms(const SearchTerms: string): string; inline;
  begin
    Result := SearchTerms + '&';
    Result := StringReplace(Result, '&&', '&', [rfReplaceAll]);
  end;
  function ExtractNext(var SearchTerms: string; const Delimiter: Char): string;
  begin
    Result := Copy(SearchTerms, 1, Pred(pos(Delimiter, SearchTerms)));
    Delete(SearchTerms, 1, pos(Delimiter, SearchTerms));
  end;
  function FindOccurrence(SearchList: TStringList): Boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 0 to Pred(SearchList.Count) do
      if ciPos(SearchList[i]) = 0
        then begin
               Result := False;
               Break;
             end;
  end;
var
	Expressions : TStringList;
	Sub         : string;
begin
  Result      := False;
  Expressions := TStringList.Create;
  try
    SearchTerms := PrepareSearchTerms(SearchTerms);
    while (pos('&', SearchTerms) > 0) and (not Result) do
      begin
        Expressions.Clear;
        Sub := ExtractNext(SearchTerms, '&');
        if RightStr(Sub, 1) <> '%'
          then Sub := Sub + '%';
        while pos('%', Sub) > 0 do
          Expressions.Add(ExtractNext(Sub, '%'));
        Result := FindOccurrence(Expressions);
      end;
  finally
    Expressions.free;
  end;
end;

function TStringStat.ciPos(const SubStr: string): Word;
begin
  Result := Pos(UpperCase(SubStr), UpperCase(FString));
end;

function TStringStat.Compare(const OtherString: string): Byte;
type
  TLink = array[0..1] of Byte;
var
  tmpPattern : TLink;
  PatternA,
  PatternB   : array of TLink;
  IndexA,
  IndexB,
  LengthStr  : Integer;
begin
  Result := 100;

  // Building pattern tables
  LengthStr := Max(FString.Length, OtherString.Length);
  for IndexA := 1 to LengthStr do
    begin
      if FString.Length >= IndexA
        then begin
               SetLength(PatternA, (Length(PatternA) + 1));
               PatternA[Length(PatternA) - 1][0] := Byte(FString[IndexA]);
               PatternA[Length(PatternA) - 1][1] := IndexA;
             end;
      if OtherString.Length >= IndexA
        then begin
               SetLength(PatternB, (Length(PatternB) + 1));
               PatternB[Length(PatternB) - 1][0] := Byte(OtherString[IndexA]);
               PatternB[Length(PatternB) - 1][1] := IndexA;
             end;
    end;

  // Quick Sort of pattern tables
  IndexA := 0;
  IndexB := 0;
  while ((IndexA < (Length(PatternA) - 1)) and (IndexB < (Length(PatternB) - 1))) do
    begin
      if Length(PatternA) > IndexA
        then begin
               if PatternA[IndexA][0] < PatternA[IndexA + 1][0]
                 then begin
                        tmpPattern[0]           := PatternA[IndexA][0];
                        tmpPattern[1]           := PatternA[IndexA][1];
                        PatternA[IndexA][0]     := PatternA[IndexA + 1][0];
                        PatternA[IndexA][1]     := PatternA[IndexA + 1][1];
                        PatternA[IndexA + 1][0] := tmpPattern[0];
                        PatternA[IndexA + 1][1] := tmpPattern[1];
                        if IndexA > 0
                          then Dec(IndexA);
                      end
                 else Inc(IndexA);
             end;
      if Length(PatternB) > IndexB
        then begin
               if PatternB[IndexB][0] < PatternB[IndexB + 1][0]
                 then begin
                        tmpPattern[0]           := PatternB[IndexB][0];
                        tmpPattern[1]           := PatternB[IndexB][1];
                        PatternB[IndexB][0]     := PatternB[IndexB + 1][0];
                        PatternB[IndexB][1]     := PatternB[IndexB + 1][1];
                        PatternB[IndexB + 1][0] := tmpPattern[0];
                        PatternB[IndexB + 1][1] := tmpPattern[1];
                        if IndexB > 0
                          then Dec(IndexB);
                      end
                 else Inc(IndexB);
             end;
    end;

  // Calculating simularity percentage
  LengthStr := Min(Length(PatternA), Length(PatternB));
  for IndexA := 0 to (LengthStr - 1) do
    begin
      if PatternA[IndexA][0] = PatternB[IndexA][0]
        then begin
               if Max(PatternA[IndexA][1], PatternB[IndexA][1]) -
                  Min(PatternA[IndexA][1], PatternB[IndexA][1]) > 0
                  then Dec(Result, ((100 div LengthStr) div (Max(PatternA[IndexA][1], PatternB[IndexA][1]) - Min(PatternA[IndexA][1], PatternB[IndexA][1]))))
                  else if Result < 100
                         then Inc(Result);
             end
        else Dec(Result, (100 div LengthStr));
    end;
  SetLength(PatternA, 0);
  SetLength(PatternB, 0);
end;

function TStringStat.ContainsOnly(const CharList: TCharSet): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to FString.Length do
    if not (FString[i] in CharList)
      then Exit;
  Result := True;
end;

constructor TStringStat.Create(const aString: string);
begin
  FString := aString;
end;

class function TStringStat.New(const aString: string): IStringStat;
begin
  Result := Create(aString);
end;

function TStringStat.OccurrenciesOf(const Ch: Char): Word;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to FString.Length do
    if FString[i] = Ch
      then Inc(Result);
end;

end.
