unit uTRandomKeyTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TRandomKeyTest = class(TObject)
  public
    [Test]
    [TestCase('Random Key 1','1')]
    [TestCase('Random Key 2','2')]
    [TestCase('Random Key 4','4')]
    [TestCase('Random Key 8','8')]
    [TestCase('Random Key 16','16')]
    [TestCase('Random Key 32','32')]
    [TestCase('Random Key 64','64')]
    [TestCase('Random Key 128','128')]
    procedure RandomKeyTest(const KeySize: Byte);
  end;

implementation

uses
    RO.TRandomKey
  ;

{ TRandomKeyTest }

procedure TRandomKeyTest.RandomKeyTest(const KeySize: Byte);
begin
  Assert.AreEqual<Byte>(
    KeySize,
    Length(TRandomKey.New(KeySize).AsString)
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TRandomKeyTest);
end.
