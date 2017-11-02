unit uTBase64Test;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TBase64Test = class(TObject)
  public
    [Test]
    [TestCase('TBase64 1', 'xpto,eHB0bw==')]
    [TestCase('TBase64 2', '1234,MTIzNA==')]
    [TestCase('TBase64 3', ',')]
    procedure TBase64ValueTest(const AValue, AResult: AnsiString);
  end;

  [TestFixture]
  TUnBase64Test = class(TObject)
  public
    [Test]
    [TestCase('TUnBase64 1', 'eHB0bw==,xpto')]
    [TestCase('TUnBase64 2', 'MTIzNA==,1234')]
    [TestCase('TUnBase64 3', ',')]
    procedure TUnBase64ValueTest(const AValue, AResult: AnsiString);
  end;

implementation

uses
    RO.TBase64
  , RO.TValue
  ;

{ TBase64Test }

procedure TBase64Test.TBase64ValueTest(const AValue, AResult: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    AResult,
    TBase64.New(
      TValue<AnsiString>.New(
        AValue
      )
    ).Value
  );
end;

{ TUnBase64Test }

procedure TUnBase64Test.TUnBase64ValueTest(const AValue, AResult: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    AResult,
    TUnBase64.New(
      TValue<AnsiString>.New(
        AValue
      )
    ).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TBase64Test);
end.
