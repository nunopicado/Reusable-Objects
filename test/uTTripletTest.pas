unit uTTripletTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTripletTest = class(TObject) 
  public
    [Test]
    [TestCase('TTriplet 1', 'False,False,False')]
    [TestCase('TTriplet 2', 'True,False,False')]
    [TestCase('TTriplet 3', 'False,True,False')]
    [TestCase('TTriplet 4', 'True,True,True')]
    procedure TripletTest(const Key, Value, Flag: Boolean);
  end;

implementation

uses
    RO.TTriplet
  ;

{ TTripletTest }

procedure TTripletTest.TripletTest(const Key, Value, Flag: Boolean);
var
  Triplet: TTriplet<Boolean, Boolean, Boolean>;
begin
  Triplet := TTriplet<Boolean, Boolean, Boolean>.Create(Key, Value, Flag);
  Assert.AreEqual<Boolean>(
    Triplet.Flag,
    Triplet.Key and Triplet.Value
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TTripletTest);
end.
