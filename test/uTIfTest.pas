unit uTIfTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TIfTest = class(TObject)
  public
    [Test]
    [TestCase('True 1','True,1,1,1')]
    [TestCase('False 1','False,1,2,2')]
    procedure EvalTest(const Condition: Boolean; const v1, v2, Expected: Integer);
  end;

implementation

uses
    RO.TIf
  ;

{ TIfTest }

procedure TIfTest.EvalTest(const Condition: Boolean; const v1, v2, Expected: Integer);
begin
  Assert.AreEqual<Integer>(
    Expected,
    TIf<Integer>.New(
      Condition,
      v1,
      v2
    ).Eval
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TIfTest);
end.
