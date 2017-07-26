(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IEnum                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IEnum                                                    **)
(******************************************************************************)
(** Dependencies  : RTTI                                                     **)
(******************************************************************************)
(** Description   : Allows retrieving an enumerated value to and from any of **)
(**                 its possible representations (EnumeratedValue, String or **)
(**                 Integer                                                  **)
(** Limitations   : Numbered enumerators don't have runtime type information **)
(**                 which is the required for returning an enumerator as a   **)
(**                 string value. This means the AsString method can not be  **)
(**                 used with numbered enumerators                           **)
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

unit Obj.SSI.IEnum;

interface

type
  IEnum<TEnumerator: Record> = interface
  ['{81A660A7-744C-4BA2-A2C5-113EC5C8D976}']
    function AsString  : string;
    function AsInteger : Integer;
    function AsEnum    : TEnumerator;
  End;

implementation

end.
