(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IGeoCoordinates                                          **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
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

unit RO.TGeoCoordinate;

interface

uses
    RO.IGeoCoordinate
  , RO.IValue
  ;

type
  TGeoCoordinate = class(TInterfacedObject, IGeoCoordinate)
  private
    FCoordinate: Double;
    FCoordinateType: TGeoCoordinateType;
    constructor Create(const CoordinateType: TGeoCoordinateType; const Coordinate: Double); overload;
    procedure Validate;
  public
    class function New(const CoordinateType: TGeoCoordinateType; const Coordinate: Double): IGeoCoordinate; overload;
    class function New(const CoordinateType: TGeoCoordinateType; const Coordinate: IDouble): IGeoCoordinate; overload;
    function AsString: string;
    function AsDouble: Double;
  end;

implementation

uses
    SysUtils
  , RO.TValue
  ;

{ TMailAddress }

constructor TGeoCoordinate.Create(const CoordinateType: TGeoCoordinateType; const Coordinate: Double);
begin
  inherited Create;
  FCoordinateType := CoordinateType;
  FCoordinate     := Coordinate;
  Validate;
end;

class function TGeoCoordinate.New(const CoordinateType: TGeoCoordinateType;
  const Coordinate: Double): IGeoCoordinate;
begin
  Result := Create(CoordinateType, Coordinate);
end;

function TGeoCoordinate.AsDouble: Double;
begin
  Result := FCoordinate;
end;

function TGeoCoordinate.AsString: string;
begin
  Result := FCoordinate.ToString();
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

class function TGeoCoordinate.New(const CoordinateType: TGeoCoordinateType; const Coordinate: IDouble): IGeoCoordinate;
begin
  Result := New(CoordinateType, Coordinate.Value);
end;

end.
