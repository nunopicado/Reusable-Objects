unit uTCryptStringTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCryptStringTest = class(TObject) 
  public
    [Test]
    [TestCase('Encrypt Default 1','1234,HZO4ig==')]
    [TestCase('Encrypt Default 2','xpto,VNH/0Q==')]
    [TestCase('Encrypt Default 3',',')]
    procedure EncryptDefaultTest(const AValue, AResult: AnsiString);
    [Test]
    [TestCase('Encrypt 1','1234,bAqiPw==,abcd')]
    [TestCase('Encrypt 2','xpto,JUjlZA==,abcd')]
    [TestCase('Encrypt 3',',,abcd')]
    procedure EncryptTest(const AValue, AResult, AKey: AnsiString);
    [Test]
    [TestCase('Decrypt Default 1','HZO4ig==,1234')]
    [TestCase('Decrypt Default 2','VNH/0Q==,xpto')]
    [TestCase('Decrypt Default 3',',')]
    procedure DecryptDefaultTest(const AValue, AResult: AnsiString);
    [Test]
    [TestCase('Decrypt 1','bAqiPw==,1234,abcd')]
    [TestCase('Decrypt 2','JUjlZA==,xpto,abcd')]
    [TestCase('Decrypt 3',',')]
    procedure DecryptTest(const AValue, AResult, AKey: AnsiString);
  end;

implementation

uses
    RO.TCryptString
  ;

{ TCryptStringTest }

procedure TCryptStringTest.DecryptDefaultTest(const AValue, AResult: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    AResult,
    TCryptString.New(AValue).Decrypt
  );
end;

procedure TCryptStringTest.DecryptTest(const AValue, AResult, AKey: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    AResult,
    TCryptString.New(
      AValue,
      AKey
    ).Decrypt
  );
end;

procedure TCryptStringTest.EncryptDefaultTest(const AValue,
  AResult: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    AResult,
    TCryptString.New(AValue).Crypt
  );
end;

procedure TCryptStringTest.EncryptTest(const AValue, AResult, AKey: AnsiString);
begin
  Assert.AreEqual<AnsiString>(
    AResult,
    TCryptString.New(
      AValue,
      AKey
    ).Crypt
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TCryptStringTest);
end.
