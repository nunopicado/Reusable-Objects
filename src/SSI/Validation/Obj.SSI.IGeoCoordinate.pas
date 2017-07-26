unit Obj.SSI.IGeoCoordinate;

interface

uses
    Obj.SSI.IValue
  ;

type
  TGeoCoordinateType = (gcLatitude, gcLongitude);

  IGeoCoordinate = interface
  ['{6D48CC57-3187-47B3-A8F1-E1C7CFCFB237}']
    function ToIString: IString;
    function ToIDouble: IDouble;
  end;

implementation

end.
