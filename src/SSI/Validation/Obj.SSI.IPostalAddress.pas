(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPostalAddress                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPostalAddress                                           **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles postal address values                            **)
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
