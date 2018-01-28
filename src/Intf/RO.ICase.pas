(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICase                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICase                                                    **)
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
(** Dependencies  : Spring                                                   **)
(******************************************************************************)
(** Description   : Represents a Case statement for any given type           **)
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

unit RO.ICase;

interface

uses
    SysUtils
  ;

type
  ICase<T> = interface(IInvokable)
  ['{10889F44-8366-4E01-BB17-42745E4CEF76}']
    function SetupReferenceValue(const ReferenceValue: T): ICase<T>;
    function AddCase(const Value: T; const Action: TProc): ICase<T>;
    function AddElse(const DefaultAction: TProc): ICase<T>;
    function Perform: ICase<T>;
  end;

implementation

end.
