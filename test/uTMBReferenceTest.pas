unit uTMBReferenceTest;

interface
uses
    DUnitX.TestFramework
  , Obj.SSI.TMBReference
  ;

type
  [TestFixture]
  TMBReferenceTest = class(TObject)
  public
    [Test]
    [TestCase('Test1','999123490,11604,9991234,25.86')]
    [TestCase('Test2','760564966,11364,7605649,51.92')]
    procedure AsStringTest(const Expected: string; const Entity: Integer; const ID: Int64; const Value: Currency);
  end;

implementation

uses
    Obj.SSI.TValue
  ;

procedure TMBReferenceTest.AsStringTest(const Expected: string; const Entity: Integer; const ID: Int64; const Value: Currency);
begin
  Assert.AreEqual<string>(
    Expected,
    TMBReference.New(
      Entity,
      ID,
      Value
    ).AsString
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TMBReferenceTest);
end.
