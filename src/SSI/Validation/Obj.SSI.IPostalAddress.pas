unit Obj.SSI.IPostalAddress;

interface

uses
    Obj.SSI.IValue
  , Obj.SSI.IPTPostalCode
  , Obj.SSI.IGeoCoordinate
  ;

type
  IPostalAddress = interface
  ['{28E88EB6-F313-4D5D-9974-22C14F073D2C}']
    function ToIString: IString;
    function Address1: IString;
    function Address2: IString;
    function PostalCode: IPTPostalCode;
    function City: IString;
    function Region: IString;
    function Country: IString;
    function Latitude: IGeoCoordinate;
    function Longitude: IGeoCoordinate;
  end;

implementation

end.
