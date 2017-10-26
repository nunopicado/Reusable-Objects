unit uTZipStringTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TZipStringTest = class(TObject)
  public
    [Test]
    [TestCase('ZipString 1','AAAA')]
    [TestCase('ZipString 2','1234')]
    procedure ZipStringTest(const AString: string);
  end;

implementation

uses
    Obj.SSI.TZipString
  , Obj.SSI.TValue
  ;

{ TZipStringTest }

procedure TZipStringTest.ZipStringTest(const AString: string);
begin
  Assert.AreEqual<string>(
    AString,
    TUnzipString.New(
      TString.New(
        TZipString.New(
          TString.New(AString)
        ).Value
      )
    ).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TZipStringTest);
end.
