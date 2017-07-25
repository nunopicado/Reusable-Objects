unit uTPrimitiveTest;

interface
uses
    DUnitX.TestFramework
  , Obj.SSI.TMBReference
  ;

type
  [TestFixture]
  TPrimitiveTest = class(TObject)
  public
    [Test]
    [TestCase('Boolean 1','True')]
    [TestCase('Boolean 2','False')]
    procedure _Boolean(const Value: Boolean);
    [Test]
    [TestCase('Char 1','A')]
    [TestCase('Char 2','#0')]
    procedure _Char(const Value: Char);
    [Test]
    [TestCase('String 1','ABCDEF')]
    [TestCase('String 2','123456')]
    procedure _String(const Value: string);
    [Test]
    [TestCase('Byte 1','123')]
    procedure _Byte(const Value: Byte);
    [Test]
    [TestCase('Word 1','123')]
    procedure _Word(const Value: Word);
    [Test]
    [TestCase('LongWord 1','70123')]
    procedure _LongWord(const Value: LongWord);
    [Test]
    [TestCase('Integer 1','-70123')]
    [TestCase('Integer 2','70123')]
    procedure _Integer(const Value: Integer);
    [Test]
    [TestCase('Int64 1','-701231234')]
    [TestCase('Int64 2','701231234')]
    procedure _Int64(const Value: Int64);
    [Test]
    [TestCase('Real 1','-70123.1234')]
    [TestCase('Real 2','70123.1234')]
    procedure _Real(const Value: Real);
    [Test]
    [TestCase('Single 1','-70123.1234')]
    [TestCase('Single 2','70123.1234')]
    procedure _Single(const Value: Single);
    [Test]
    [TestCase('Double 1','-70123.1234')]
    [TestCase('Double 2','70123.1234')]
    procedure _Double(const Value: Double);
    [Test]
    [TestCase('Currency 1','-70123.1234')]
    [TestCase('Currency 2','70123.1234')]
    procedure _Currency(const Value: Currency);
    [Test]
    [TestCase('ShortInt 1','-80')]
    [TestCase('ShortInt 2','34')]
    procedure _ShortInt(const Value: ShortInt);
  end;

implementation

uses
    Obj.SSI.TPrimitive
  ;

procedure TPrimitiveTest._Boolean(const Value: Boolean);
begin
  Assert.AreEqual<boolean>(
    Value,
    TBoolean.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._String(const Value: string);
begin
  Assert.AreEqual<string>(
    Value,
    TString.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Char(const Value: Char);
begin
  Assert.AreEqual<Char>(
    Value,
    TChar.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Byte(const Value: Byte);
begin
  Assert.AreEqual<Byte>(
    Value,
    TByte.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Word(const Value: Word);
begin
  Assert.AreEqual<Word>(
    Value,
    TWord.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._LongWord(const Value: LongWord);
begin
  Assert.AreEqual<LongWord>(
    Value,
    TLongWord.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Integer(const Value: Integer);
begin
  Assert.AreEqual<Integer>(
    Value,
    TInteger.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Int64(const Value: Int64);
begin
  Assert.AreEqual<Int64>(
    Value,
    TInt64.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Real(const Value: Real);
begin
  Assert.AreEqual<Real>(
    Value,
    TReal.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Single(const Value: Single);
begin
  Assert.AreEqual<Single>(
    Value,
    TSingle.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Double(const Value: Double);
begin
  Assert.AreEqual<Double>(
    Value,
    TDouble.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._Currency(const Value: Currency);
begin
  Assert.AreEqual<Currency>(
    Value,
    TCurrency.New(
      Value
    ).Value
  );
end;

procedure TPrimitiveTest._ShortInt(const Value: ShortInt);
begin
  Assert.AreEqual<ShortInt>(
    Value,
    TPrimitive<ShortInt>.New(
      Value
    ).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TPrimitiveTest);
end.
