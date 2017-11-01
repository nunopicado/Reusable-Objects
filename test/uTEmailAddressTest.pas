unit uTEmailAddressTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TEmailAddressTest = class(TObject)
  public
    [Test]
    [TestCase('EmailAddress 1','name@domain.com,True')]
    [TestCase('EmailAddress 2','name_surname@domain.com,True')]
    [TestCase('EmailAddress 3','name.surname@domain.com,True')]
    [TestCase('EmailAddress 4','name,False')]
    [TestCase('EmailAddress 5','name@,False')]
    [TestCase('EmailAddress 6','domain.com,False')]
    [TestCase('EmailAddress 7','@domain.com,False')]
    [TestCase('EmailAddress 8','name@domain,False')]
    [TestCase('EmailAddress 9','namedomain.com,False')]
    [TestCase('EmailAddress 10','na me@domain.com,False')]
    [TestCase('EmailAddress 11','name@dom ain.com,False')]
    [TestCase('EmailAddress 12','name @domain.com,False')]
    [TestCase('EmailAddress 13',',False')]
    [TestCase('EmailAddress 14','nameç@domain.com,False')]
    [TestCase('EmailAddress 15','name@domainç.com,False')]
    procedure EmailAddressTest(const Email: string; const IsValid: Boolean);
  end;

implementation

uses
    Obj.SSI.TEmailAddress
  ;

{ TEmailAddressTest }

procedure TEmailAddressTest.EmailAddressTest(const Email: string; const IsValid: Boolean);
begin
  Assert.AreEqual<Boolean>(
    IsValid,
    TEmailAddress.New(
      Email
    ).IsValid
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TEmailAddressTest);
end.
