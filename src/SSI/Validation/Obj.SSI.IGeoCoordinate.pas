(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IGeoCoordinates                                          **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IGeoCoordinates                                          **)
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
  TGeoCoordinateType = (gcLatitude, gcLongitude);

  IGeoCoordinate = interface(IInvokable)
  ['{6D48CC57-3187-47B3-A8F1-E1C7CFCFB237}']
    function AsString: string;
    function AsDouble: Double;
  end;

implementation

end.
