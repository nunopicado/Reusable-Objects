(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IGeoCoordinates                                          **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IGeoCoordinates                                          **)
(** Classes       : TGeoCoordinates, implements IGeoCoordinates              **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles Geo Coordinates                                  **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**                 terms                                                    **)
(******************************************************************************)

unit Obj.SSI.IGeoCoordinate;

interface

type
    IGeoCoordinate = interface ['{6D48CC57-3187-47B3-A8F1-E1C7CFCFB237}']
      function ToString: String;
      function ToDouble: Double;
    end;

    TGeoCoordinateType = (gcLatitude, gcLongitude);

    TGeoCoordinate = class(TInterfacedObject, IGeoCoordinate)
    private
      FCoordinate: Double;
      FCoordinateType: TGeoCoordinateType;
      constructor Create(CoordinateType: TGeoCoordinateType; Coordinate: Double); Overload;
      procedure Validate;
    public
      class function New(CoordinateType: TGeoCoordinateType; Coordinate: Double): IGeoCoordinate;
      function ToString: String;
      function ToDouble: Double;
    end;

implementation

uses
    SysUtils;

{ TMailAddress }

constructor TGeoCoordinate.Create(CoordinateType: TGeoCoordinateType; Coordinate: Double);
begin
     inherited Create;
     FCoordinateType := CoordinateType;
     FCoordinate     := Coordinate;
     Validate;
end;

function TGeoCoordinate.ToDouble: Double;
begin
     Result := FCoordinate;
end;

function TGeoCoordinate.ToString: String;
begin
     Result := FCoordinate.ToString;
end;

procedure TGeoCoordinate.Validate;
var
   Valid: Boolean;
begin
     Valid := ((FCoordinateType = gcLatitude) and (FCoordinate >= -90) and (FCoordinate <= 90)) or
              ((FCoordinateType = gcLongitude) and (FCoordinate >= -180) and (FCoordinate <= 180));

     if not Valid
        then raise exception.Create(Format('"%d" is not a valid geo coordinate.', [FCoordinate]));
end;

class function TGeoCoordinate.New(CoordinateType: TGeoCoordinateType; Coordinate: Double): IGeoCoordinate;
begin
     Result := Create(CoordinateType, Coordinate);
end;

end.
