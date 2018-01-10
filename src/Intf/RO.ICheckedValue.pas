(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICheckedValue<T>                                         **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICheckedValue<T>                                         **)
(******************************************************************************)
(** Enumerators   :                                                          **)
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
(** Description   : An IValue<T> extension with an aggregated boolean field  **)
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

unit RO.ICheckedValue;

interface

uses
    RO.IValue
  ;

type
  ICheckedValue<T> = interface(IValue<T>)
  ['{61B2114B-989B-4A38-890C-F022699C6B93}']
    function Checked: Boolean;
    function Swap: ICheckedValue<T>;
  end;

implementation

end.
