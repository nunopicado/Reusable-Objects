unit uPTPostalCodeTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TPTPostalCodeTest = class(TObject)
  public
    [Test]
    [TestCase('PTPostalCode AsString 1','3750-000,3750-000')]
    [TestCase('PTPostalCode AsString 2','3750-123,3750-123')]
    procedure PTPostalCodeAsStringTest(const ValueIn, ValueOut: string);
    [Test]
    [TestCase('PTPostalCode Invalid 1','')]
    [TestCase('PTPostalCode Invalid 2','3750')]
    [TestCase('PTPostalCode Invalid 3','3750-')]
    [TestCase('PTPostalCode Invalid 4','3750-1')]
    [TestCase('PTPostalCode Invalid 5','3750-12')]
    [TestCase('PTPostalCode Invalid 6','375-123')]
    [TestCase('PTPostalCode Invalid 7','37-123')]
    [TestCase('PTPostalCode Invalid 8','3-123')]
    [TestCase('PTPostalCode Invalid 9','-123')]
    [TestCase('PTPostalCode Invalid 10','AAAA-BBB')]
    procedure PTPostalCodeInvalidTest(const ValueIn: string);
  end;

  [TestFixture]
  TPTCP7Test = class(TObject)
  public
    [Test]
    [TestCase('PTPostalCode CP7 AsString 1','3750-000,3750000')]
    [TestCase('PTPostalCode CP7 AsString 2','3750-123,3750123')]
    procedure PTPostalCodeCP7AsStringTest(const ValueIn, ValueOut: string);
  end;

  [TestFixture]
  TPTCP4Test = class(TObject)
  public
    [Test]
    [TestCase('PTPostalCode CP4 AsString 1','3750-000,3750')]
    [TestCase('PTPostalCode CP4 AsString 2','3750-123,3750')]
    procedure PTPostalCodeCP4AsStringTest(const ValueIn, ValueOut: string);
  end;

  [TestFixture]
  TPTCP3Test = class(TObject)
  public
    [Test]
    [TestCase('PTPostalCode CP3 AsString 1','3750-000,000')]
    [TestCase('PTPostalCode CP3 AsString 2','3750-123,123')]
    procedure PTPostalCodeCP3AsStringTest(const ValueIn, ValueOut: string);
  end;

implementation

uses
    RO.TPTPostalCode
  ;

{ TPTPostalCodeTest }

procedure TPTPostalCodeTest.PTPostalCodeAsStringTest(const ValueIn,
  ValueOut: string);
begin
  Assert.AreEqual<string>(
    ValueOut,
    TPTPostalCode.New(ValueIn).AsString
  );
end;

procedure TPTPostalCodeTest.PTPostalCodeInvalidTest(const ValueIn: string);
begin
  Assert.WillRaise(
    procedure
    begin
      TPTPostalCode.New(ValueIn);
    end
  );
end;

{ TPTCP7Test }

procedure TPTCP7Test.PTPostalCodeCP7AsStringTest(const ValueIn,
  ValueOut: string);
begin
  Assert.AreEqual<string>(
    ValueOut,
    TPTCP7.New(
      TPTPostalCode.New(
        ValueIn
      )
    ).AsString
  );
end;

{ TPTCP3Test }

procedure TPTCP3Test.PTPostalCodeCP3AsStringTest(const ValueIn,
  ValueOut: string);
begin
  Assert.AreEqual<string>(
    ValueOut,
    TPTCP3.New(
      TPTPostalCode.New(
        ValueIn
      )
    ).AsString
  );
end;

{ TPTCP4Test }

procedure TPTCP4Test.PTPostalCodeCP4AsStringTest(const ValueIn,
  ValueOut: string);
begin
  Assert.AreEqual<string>(
    ValueOut,
    TPTCP4.New(
      TPTPostalCode.New(
        ValueIn
      )
    ).AsString
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TPTPostalCodeTest);
end.
