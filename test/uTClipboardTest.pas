unit uTClipboardTest;

interface
uses
  DUnitX.TestFramework,
  Obj.FMX.TClipboard;

type
  [TestFixture]
  TClipboardTest = class(TObject)
  public
    [Test]
    [TestCase('Valid 1','123456,123456,True')]
    [TestCase('Valid 2','ABCDEF,ABCDEF,True')]
    [TestCase('Invalid 1','123456,654321,False')]
    [TestCase('Invalid 2','ABCDEF,FEDCBA,False')]
    procedure Validation(const Copied, Pasted: string; const Expected: Boolean);
  end;

implementation

{ TPTVATNumberTest }

procedure TClipboardTest.Validation(const Copied, Pasted: string; const Expected: Boolean);
begin
  Assert.AreEqual(
    Expected,
    Pasted = TClipboard.New.Copy(Copied).Paste
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TClipboardTest);
end.
