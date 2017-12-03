(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IIntegerRange, IFloatRange, ICharRange                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IRange                                                   **)
(**                 IIntegerRange, IFloatRange, ICharRange                   **)
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
(** Description   : Represents an ordinal value range (Integer, Float or     **)
(**                 char, and allows questioning the range about the         **)
(**                 existence or inexistence of a value inside that range    **)
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

unit RO.IRange;

interface

type
  IRange<T: record> = interface(IInvokable)
  ['{5FE5BB8E-F241-4A84-BFF7-555BA9320A2D}']
    function Includes(const Value: T): Boolean;
    function Excludes(const Value: T): Boolean;
  end;

  IIntegerRange = IRange<Int64>;
  IFloatRange   = IRange<Extended>;
  ICharRange    = IRange<Char>;

implementation

end.
