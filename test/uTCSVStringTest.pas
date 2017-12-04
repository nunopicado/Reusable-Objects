unit uTCSVStringTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TCSVStringTest = class(TObject) 
  public
    [Test]
    [TestCase('TCSVString.Count 1', 'A;B;C;D,4')]
    [TestCase('TCSVString.Count 2', 'A;B;,3')]
    procedure CountTest(const CSVString: string; const Count: Byte);
    [Test]
    [TestCase('TCSVString.Field 1', 'A;B;C;D,4,D')]
    [TestCase('TCSVString.Field 2', 'A;B;,3,')]
    [TestCase('TCSVString.Field 3', 'A;B;,1,A')]
    procedure FieldTest(const CSVString: string; const Index: Byte; const Expected: string);
    [Test]
    [TestCase('TCSVString.FieldDefault 1', 'A;;C;D,2,B')]
    [TestCase('TCSVString.FieldDefault 2', 'A;B;,3,C')]
    [TestCase('TCSVString.FieldDefault 3', 'A;B,6,F')]
    procedure DefaultTest(const CSVString: string; const Index: Byte; const Expected: string);
  end;

implementation

uses
    RO.TCSVString
  ;

{ TCSVStringTest }

procedure TCSVStringTest.CountTest(const CSVString: string; const Count: Byte);
begin
  Assert.AreEqual<Byte>(
    Count,
    TCSVString.New(CSVString, ';')
      .Count
  );
end;

procedure TCSVStringTest.DefaultTest(const CSVString: string; const Index: Byte;
  const Expected: string);
begin
  Assert.AreEqual<string>(
    Expected,
    TCSVString.New(CSVString, ';')
      .Field(Index, Expected)
  );
end;

procedure TCSVStringTest.FieldTest(const CSVString: string; const Index: Byte;
  const Expected: string);
begin
  Assert.AreEqual<string>(
    Expected,
    TCSVString.New(CSVString, ';')
      .Field(Index)
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TCSVStringTest);
end.
