unit uTAES128Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TAES128Test = class(TObject) 
  public
    [Test]
    [TestCase('AES128 1','1234,sbpCAISFpLu6Y7vSfAtDUg==,4798233419457937')]
    [TestCase('AES128 2','xpto,ta7XiWpy5Ao6rmO9kxPC8w==,5757486374927324')]
    procedure AES128Test(const AString, AnEncryptedString, Key: string);
    [Test]
    [TestCase('AES128 Fail 1','1234,sbpCAISFpLu6Y7vSfAtDUg==,1111,Invalid key size')]
    [TestCase('AES128 Fail 2',',sbpCAISFpLu6Y7vSfAtDUg==,5757486374927324,Data must not be empty')]
    procedure AES128FailTest(const AString, AnEncryptedString, Key, ErrorMsg: string);
  end;

implementation

uses
    Obj.SSI.TAES128
  , Obj.SSI.TValue
  , SysUtils
  ;

{ TAES128Test }

procedure TAES128Test.AES128FailTest(const AString, AnEncryptedString,
  Key, ErrorMsg: string);
begin
  Assert.WillRaise(
    procedure
    begin
      TAES128.New(
        TString.New(AString),
        Key
      ).Value
    end,
    Exception,
    ErrorMsg
  );
end;

procedure TAES128Test.AES128Test(const AString, AnEncryptedString, Key: string);
begin
  Assert.AreEqual<string>(
    AnEncryptedString,
    TAES128.New(
      TString.New(AString),
      Key
    ).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TAES128Test);
end.
