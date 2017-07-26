(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISliderMsg                                               **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Dependencies  : FMX                                                      **)
(******************************************************************************)
(** Description   : An FMX message pop-up interface, to be used with a       **)
(**                 a slider message component                               **)
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

unit Obj.FMX.ISliderMsg;

interface

type
  ISliderMsg = interface
  ['{FE0C3FD7-CCC4-4B48-88AD-90286B4E0BBA}']
    function Show: ISliderMsg;
    function Hide: ISliderMsg;
  end;

implementation

end.
