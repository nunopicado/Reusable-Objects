(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISNTPTime                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ISNTPTime                                                **)
(******************************************************************************)
(** Enumerators   : TSPBehavior                                              **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Retrieves a date and time from a NTP Server              **)
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

unit RO.ISNTPTime;

interface

uses
    RO.IDate
  ;

type
  TSPBehavior = (spThrowException, spReturnCurrentDate);

  ISNTPTime = interface(IInvokable)
  ['{BFE1C861-89E5-4F8C-B0B1-3CEA18845737}']
    function Now: TDateTime;
  end;

implementation

end.
