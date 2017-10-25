unit uPTVATNumberTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TPTVATNumberTest = class(TObject) 
  public
    [Test]
    [TestCase('Valid 1','555555550,True')]
    [TestCase('Valid 2','999999990,True')]
    [TestCase('Valid 3','123456789,True')]
    [TestCase('Invalid 1','111111111,False')]
    [TestCase('Invalid 2','123,False')]
    [TestCase('Invalid 3',',False')]
    procedure IsValidTest(const VATNumber: string; const Expected: Boolean);
  end;

implementation

uses
    Obj.SSI.TPTVATNumber
  ;

{ TPTVATNumberTest }

procedure TPTVATNumberTest.IsValidTest(const VATNumber: string; const Expected: Boolean);
begin
  Assert.AreEqual(
    Expected,
    TPTVATNumber.New(VATNumber).IsValid
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TPTVATNumberTest);
end.
