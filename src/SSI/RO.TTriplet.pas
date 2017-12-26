(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        :                                                          **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TTriplet                                                 **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : A generic 3 value record                                 **)
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

unit RO.TTriplet;

interface

type
  TTriplet<TKey, TValue, TFlag> = record
    Key   : TKey;
    Value : TValue;
    Flag  : TFlag;
    constructor Create(const aKey: TKey; const aValue: TValue; const aFlag: TFlag);
  end;

implementation

{ TTriplet<TKey, TValue, TFlag> }

constructor TTriplet<TKey, TValue, TFlag>.Create(const aKey: TKey; const aValue: TValue; const aFlag: TFlag);
begin
  Key   := aKey;
  Value := aValue;
  Flag  := aFlag;
end;

end.
