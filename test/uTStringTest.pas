unit uTStringTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TStringTest = class(TObject)
  public
    [Test]
    [TestCase('TNumbersOnly 1', '123456,abc123def456')]
    [TestCase('TNumbersOnly 2', ',abcdef')]
    procedure _NumbersOnly(const Expected, Value: string);
    [Test]
    [TestCase('TGroupDigits 1', '1,3,1')]
    [TestCase('TGroupDigits 2', '12,3,12')]
    [TestCase('TGroupDigits 3', '123,3,123')]
    [TestCase('TGroupDigits 4', '1 234,3,1234')]
    [TestCase('TGroupDigits 5', '12 345,3,12345')]
    [TestCase('TGroupDigits 6', '123 456,3,123456')]
    [TestCase('TGroupDigits 7', '1 234 567,3,1234567')]
    [TestCase('TGroupDigits 8', '1 23,2,123')]
    [TestCase('TGroupDigits 9', '12 34,2,1234')]
    [TestCase('TGroupDigits 10', '1 23 45,2,12345')]
    [TestCase('TGroupDigits 11', '12 34 56,2,123456')]
    [TestCase('TGroupDigits 12', '1 23 45 67,2,1234567')]
    procedure _GroupDigits(const Expected: string; const NumDigits: Integer; const Value: string);
    [Test]
    [TestCase('TCut 1', 'abcdef,6,abcdefghijkm')]
    [TestCase('TCut 2', 'abc,3,abcdef')]
    procedure _Cut(const Expected: string; const Chars: Integer; const Value: string);
    [Test]
    [TestCase('TDefault 1', 'ghijk,,ghijk')]
    [TestCase('TDefault 2', 'abcdef,abcdef,ghijk')]
    procedure _Default(const Expected, Value, Default: string);
    [Test]
    [TestCase('TInitialCaps 1', 'Hello World,hello world')]
    [TestCase('TInitialCaps 2', 'S.A.,s.a.')]
    [TestCase('TInitialCaps 3', '[Gone],[gone]')]
    procedure _InitialCaps(const Expected, Value: string);
  end;

implementation

uses
    RO.TString
  , RO.IValue
  , RO.TValue
  , Delphi.Mocks
  ;


{ TStringTest }

procedure TStringTest._NumbersOnly(const Expected, Value: string);
var
  IStringMock: TMock<IString>;
begin
  IStringMock := TMock<IString>.Create;
  IStringMock.Setup.WillReturn(Value).When.Value;

  Assert.AreEqual(
    Expected,
    TNumbersOnly.New(
      IStringMock
    ).Value
  );
end;

procedure TStringTest._Cut(const Expected: string; const Chars: integer; const Value: string);
var
  IStringMock: TMock<IString>;
begin
  IStringMock := TMock<IString>.Create;
  IStringMock.Setup.WillReturn(Value).When.Value;

  Assert.AreEqual<string>(
    Expected,
    TCut.New(
      IStringMock,
      Chars
    ).Value
  );
end;

procedure TStringTest._Default(const Expected, Value, Default: string);
var
  IStringMockValue: TMock<IString>;
  IStringMockDefault: TMock<IString>;
begin
  IStringMockValue := TMock<IString>.Create;
  IStringMockValue.Setup.WillReturn(Value).When.Value;
  IStringMockDefault := TMock<IString>.Create;
  IStringMockDefault.Setup.WillReturn(Default).When.Value;

  Assert.AreEqual(
    Expected,
    TDefault.New(
      IStringMockValue,
      IStringMockDefault
    ).Value
  );
end;

procedure TStringTest._GroupDigits(const Expected: string; const NumDigits: Integer; const Value: string);
var
  IStringMock: TMock<IString>;
begin
  IStringMock := TMock<IString>.Create;
  IStringMock.Setup.WillReturn(Value).When.Value;

  Assert.AreEqual(
    Expected,
    TGroupDigits.New(
      IStringMock,
      NumDigits
    ).Value
  );
end;

procedure TStringTest._InitialCaps(const Expected, Value: string);
var
  IStringMock: TMock<IString>;
begin
  IStringMock := TMock<IString>.Create;
  IStringMock.Setup.WillReturn(Value).When.Value;

  Assert.AreEqual(
    Expected,
    TInitialCaps.New(
      IStringMock
    ).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TStringTest);
end.
