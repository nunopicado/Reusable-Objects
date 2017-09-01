(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IEmailAddress                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IEmailAddress                                            **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles email address string values                      **)
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

unit Obj.SSI.IEmailAddress;

interface

type
  IEmailAddress = interface(IInvokable)
  ['{C3F80B3B-D3F0-47B7-BE90-B6EBD0505E8C}']
    function Value: string;
    function IsValid: Boolean;
  end;

implementation

end.
