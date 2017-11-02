unit uTGeoCoordinateTest;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TGeoCoordinateTest = class(TObject)
  public
    [Test]
    [TestCase('Coordinate as double 1','0,0')]
    [TestCase('Coordinate as double 2','90,90')]
    [TestCase('Coordinate as double 3','180,180')]
    [TestCase('Coordinate as double 4','-90,-90')]
    [TestCase('Coordinate as double 5','-180,-180')]
    procedure CoordinateToDoubleTest(const ValueIn, ValueOut: Double);
    [Test]
    [TestCase('Coordinate as string 1','0,0')]
    [TestCase('Coordinate as string 2','90,90')]
    [TestCase('Coordinate as string 3','180,180')]
    [TestCase('Coordinate as string 4','-90,-90')]
    [TestCase('Coordinate as string 5','-180,-180')]
    procedure CoordinateToStringTest(const ValueIn: Double; const ValueOut: string);
    [Test]
    [TestCase('Coordinate latitude validation 1','-91')]
    [TestCase('Coordinate latitude validation 2','91')]
    procedure CoordinateLatitudeTest(const ValueIn: Double);
    [Test]
    [TestCase('Coordinate longitude validation 1','-181')]
    [TestCase('Coordinate longitude validation 2','181')]
    procedure CoordinateLongitudeTest(const ValueIn: Double);
  end;

implementation

uses
    RO.IGeoCoordinate
  , RO.TGeoCoordinate
  ;

{ TGeoCoordinateTest }

procedure TGeoCoordinateTest.CoordinateLatitudeTest(const ValueIn: Double);
begin
  Assert.WillRaise(
    procedure
    begin
      TGeoCoordinate.New(
        TGeoCoordinateType.gcLatitude,
        ValueIn
      )
    end
  );
end;

procedure TGeoCoordinateTest.CoordinateLongitudeTest(const ValueIn: Double);
begin
  Assert.WillRaise(
    procedure
    begin
      TGeoCoordinate.New(
        TGeoCoordinateType.gcLongitude,
        ValueIn
      )
    end
  );
end;

procedure TGeoCoordinateTest.CoordinateToDoubleTest(const ValueIn, ValueOut: Double);
begin
  Assert.AreEqual<Double>(
    ValueOut,
    TGeoCoordinate.New(
      TGeoCoordinateType.gcLongitude,
      ValueIn
    ).AsDouble
  );
end;

procedure TGeoCoordinateTest.CoordinateToStringTest(const ValueIn: Double; const ValueOut: string);
begin
  Assert.AreEqual<string>(
    ValueOut,
    TGeoCoordinate.New(
      TGeoCoordinateType.gcLongitude,
      ValueIn
    ).AsString
  );
end;

initialization
  TDUnitX.RegisterTestFixture(TGeoCoordinateTest);
end.
