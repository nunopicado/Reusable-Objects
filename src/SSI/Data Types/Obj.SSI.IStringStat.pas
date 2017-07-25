unit Obj.SSI.IStringStat;

interface

type
  TCharSet = Set of Char;
  IStringStat = Interface
  ['{31A932DC-C98B-4C9F-B608-111EA84C7BAA}']
    function OccurrenciesOf(const Ch: Char): Word;
    function ciPos(const SubStr: string): Word;
    function Compare(const OtherString: string): Byte;
    function AdvSearch(SearchTerms: string): Boolean;
    function ContainsOnly(const CharList: TCharSet): Boolean;
  End;

implementation

end.
