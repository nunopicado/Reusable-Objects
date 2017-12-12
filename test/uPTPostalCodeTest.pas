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
    [TestCase('PTPostalCode IsValid 1',',False')]
    [TestCase('PTPostalCode IsValid 2','3750,False')]
    [TestCase('PTPostalCode IsValid 3','3750-,False')]
    [TestCase('PTPostalCode IsValid 4','3750-1,False')]
    [TestCase('PTPostalCode IsValid 5','3750-12,False')]
    [TestCase('PTPostalCode IsValid 6','375-123,False')]
    [TestCase('PTPostalCode IsValid 7','37-123,False')]
    [TestCase('PTPostalCode IsValid 8','3-123,False')]
    [TestCase('PTPostalCode IsValid 9','-123,False')]
    [TestCase('PTPostalCode IsValid 10','AAAA-BBB,False')]
    [TestCase('PTPostalCode IsValid 11','3750-143,True')]
    [TestCase('PTPostalCode IsValid 12','1450-122,True')]
    [TestCase('PTPostalCode IsValid 13','AAAA-BBBB,False')]
    [TestCase('PTPostalCode IsValid 14','0000-123,False')]
    [TestCase('PTPostalCode IsValid 15','1111-2222,False')]
    procedure PTPostalCodeIsValidTest(const ValueIn: string; const Valid: Boolean);
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

procedure TPTPostalCodeTest.PTPostalCodeIsValidTest(const ValueIn: string; const Valid: Boolean);
begin
  Assert.AreEqual<Boolean>(
    Valid,
    TPTPostalCode.New(ValueIn)
      .IsValid
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
