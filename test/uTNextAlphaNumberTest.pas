unit uTNextAlphaNumberTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TNextAlphaNumberTest = class(TObject) 
  public
    [Test]
    [TestCase('TNextAlphaNumber Value 1','A,B')]
    [TestCase('TNextAlphaNumber Value 2','C,D')]
    [TestCase('TNextAlphaNumber Value 3','Z,AA')]
    [TestCase('TNextAlphaNumber Value 4','AZ,BA')]
    [TestCase('TNextAlphaNumber Value 5','ZH,ZI')]
    [TestCase('TNextAlphaNumber Value 6','ZZ,AAA')]
    [TestCase('TNextAlphaNumber Value 7','AAZ,ABA')]
    [TestCase('TNextAlphaNumber Value 8','ZZY,ZZZ')]
    [TestCase('TNextAlphaNumber Value 9','ZZZ,AAAA')]
    procedure TNextAlphaNumberValueTest(const Current, Next: string);
  end;

implementation

uses
    RO.TNextAlphaNumber
  , RO.IValue
  , Delphi.Mocks
  , SysUtils
  ;

{ TNextAlphaNumberTest }

procedure TNextAlphaNumberTest.TNextAlphaNumberValueTest(const Current, Next: string);
var
  MockValue: TMock<IString>;
begin
  MockValue := TMock<IString>.Create;
  MockValue.Setup.WillReturn(Current).When.Value;
  Assert.AreEqual(
    Next,
    TNextAlphaNumber.New(
      MockValue
    ).Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TNextAlphaNumberTest);
end.
