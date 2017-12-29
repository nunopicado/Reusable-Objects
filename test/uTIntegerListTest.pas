unit uTIntegerListTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TIntegerListTest = class(TObject) 
  public
    [Test]
    [TestCase('IntegerList 1', '1..10;10', ';')]
    [TestCase('IntegerList 2', '1,3..10;19', ';')]
    procedure IntegerListTest(const Criteria: string; LastValue: Integer);
  end;

implementation

uses
    RO.TIntegerList
  ;

{ TIntegerListTest }

procedure TIntegerListTest.IntegerListTest(const Criteria: string; LastValue: Integer);
begin
  Assert.AreEqual<Integer>(
    LastValue,
    TIntegerList.New(
      Criteria
    ).Last
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TIntegerListTest);
end.
