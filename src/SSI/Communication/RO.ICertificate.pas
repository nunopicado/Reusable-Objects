(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICertificate                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICertificate                                             **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Handles PFX certificate files                            **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit RO.ICertificate;

interface

type
  ICertificate = interface
  ['{A90214F2-64DE-49C2-8611-3B235812330A}']
    function AsPCCert_Context: Pointer;
    function ContextSize: Cardinal;
    function IsValid: Boolean;
    function SerialNumber: string;
    function NotAfter: TDateTime;
  end;

implementation

end.
