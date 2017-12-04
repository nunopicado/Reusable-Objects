unit uTByteSequenceTest;

interface
uses
    DUnitX.TestFramework
  , RO.TByteSequence
  ;

type
  [TestFixture]
  TByteSequenceTest = class(TObject)
  public
    [Test]
    [TestCase('NewFromString 1','ABC,0,65')]
    [TestCase('NewFromString 2','ABC,1,66')]
    [TestCase('NewFromString 3','ABC,2,67')]
    procedure NewFromStringTest(const Sequence: AnsiString; const Index, Expected: Byte);
    [Test]
    [TestCase('NewFromDecimal 1','065066067,0,65')]
    [TestCase('NewFromDecimal 2','065066067,1,66')]
    [TestCase('NewFromDecimal 3','065066067,2,67')]
    procedure NewTest(const Sequence: AnsiString; const Index, Expected: Byte);
    [Test]
    [TestCase('AsString 1','065066067,ABC')]
    [TestCase('AsString 2','065066067049050051,ABC123')]
    procedure AsStringTest(const Sequence: AnsiString; const Expected: AnsiString);
  end;

implementation


{ TByteSequenceTest }

procedure TByteSequenceTest.AsStringTest(const Sequence, Expected: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    Expected,
    TByteSequence.NewFromDecimal(
      Sequence
    ).AsString
  );
end;

procedure TByteSequenceTest.NewFromStringTest(const Sequence: AnsiString; const Index, Expected: Byte);
begin
  Assert.AreEqual<Byte>(
    Expected,
    TByteSequence.NewFromString(Sequence)
      .AsEnumerable
        .ElementAt(Index)
  );
end;

procedure TByteSequenceTest.NewTest(const Sequence: AnsiString; const Index, Expected: Byte);
begin
  Assert.AreEqual<Byte>(
    Expected,
    TByteSequence.NewFromDecimal(Sequence)
      .AsEnumerable
        .ElementAt(Index)
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TByteSequenceTest);
end.
