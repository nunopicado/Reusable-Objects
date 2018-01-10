unit uTCheckedValueTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCheckedValueTest = class(TObject) 
  public
    [Test]
    [TestCase('Checked 1','Checked,True')]
    [TestCase('Checked 2','Unchecked,False')]
    procedure CheckedTest(const Value: string; const Checked: Boolean);
    [Swap]
    [TestCase('Checked 1','Unchecked,True')]
    [TestCase('Checked 2','Checked,False')]
    procedure SwapTest(const Value: string; const Checked: Boolean);
  end;

implementation

uses
    RO.TCheckedValue
  ;

{ TCheckedValueTest }

procedure TCheckedValueTest.CheckedTest(const Value: string;
  const Checked: Boolean);
begin
  Assert.AreEqual<Boolean>(
    Checked,
    TCheckedValue<string>.New(
      Value,
      Checked
    )
      .Checked
  );
end;

procedure TCheckedValueTest.SwapTest(const Value: string;
  const Checked: Boolean);
begin
  Assert.AreEqual<Boolean>(
    not Checked,
    TCheckedValue<string>.New(
      Value,
      Checked
    )
      .Swap
      .Checked
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TCheckedValueTest);
end.
