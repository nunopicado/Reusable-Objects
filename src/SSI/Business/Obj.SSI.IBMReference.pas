(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMBReference                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMBReference                                             **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Generates MB (Portuguese ATM) payment references         **)
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

unit Obj.SSI.IBMReference;

interface

uses
    Obj.SSI.IValue
  ;

type
  IMBReference = Interface
  ['{9D22DEC3-42A7-4D7D-A1E5-76F13D77938F}']
    function AsIString: IString;
  End;

implementation

end.
