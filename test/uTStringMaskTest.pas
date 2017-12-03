unit uTStringMaskTest;

interface
uses
    DUnitX.TestFramework
  , RO.TStringMask
  ;

type
  [TestFixture]
  TStringMaskTest = class(TObject)
  public
    [Test]
    [TestCase('TStringMask 1', 'XX##X##X,12345678,3467')]
    [TestCase('TStringMask 2', '***--,ABCDE,ABC')]
    [TestCase('TStringMask 3', 'YNYNYN,ABCDEF,ACE')]
    [TestCase('TStringMask 4', '--++++--,12345678,3456')]
    [TestCase('TStringMask 5', '+++++,ABCDEFGHIH,ABCDE')]
    [TestCase('TStringMask 6', '--,ABCDE,')]
    procedure ParseTest(const Mask, Str, Expected: string);
  end;

implementation


{ TStringMaskTest }

procedure TStringMaskTest.ParseTest(const Mask, Str, Expected: string);
begin
  Assert.AreEqual<string>(
    Expected,
    TStringMask.New(Mask)
      .Parse(Str)
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TStringMaskTest);
end.
