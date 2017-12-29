unit uTIntegerListTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TIntegerListTest = class(TObject) 
  public
    [Test]
    [TestCase('IntegerList 1', '1,2,10,10')]
    [TestCase('IntegerList 2', '1,3,10,19')]
    procedure IntegerListStepXTest(const FirstValue, SecondValue, ElementCount, LastValue: Integer);
    [Test]
    [TestCase('IntegerList 3', '1,10,10')]
    procedure IntegerListStep1Test(const FirstValue, ElementCount, LastValue: Integer);
  end;

implementation

uses
    RO.TIntegerList
  ;

{ TIntegerListTest }

procedure TIntegerListTest.IntegerListStep1Test(const FirstValue, ElementCount, LastValue: Integer);
begin
  Assert.AreEqual<Integer>(
    LastValue,
    TIntegerList.New(
      FirstValue,
      ElementCount
    )
      .Last
  );
end;

procedure TIntegerListTest.IntegerListStepXTest(const FirstValue, SecondValue, ElementCount, LastValue: Integer);
begin
  Assert.AreEqual<Integer>(
    LastValue,
    TIntegerList.New(
      FirstValue,
      SecondValue,
      ElementCount
    )
      .Last
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TIntegerListTest);
end.
