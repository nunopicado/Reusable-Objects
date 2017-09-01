(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IValue                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IValue                                                   **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Represents a value that will be defined at the moment it **)
(**                   is first called upon                                   **)
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

unit Obj.SSI.IValue;

interface

type
  IValue<T> = interface(IInvokable)
  ['{21E1AA41-099A-49FA-8C9B-2CA3A37BAD25}']
    function Value: T;
    function Refresh: IValue<T>;
  end;

  IBoolean  = IValue<Boolean>;
  IChar     = IValue<Char>;
  IString   = IValue<string>;
  IByte     = IValue<Byte>;
  IWord     = IValue<Word>;
  ILongWord = IValue<LongWord>;
  IInteger  = IValue<Integer>;
  IInt64    = IValue<Int64>;
  IReal     = IValue<Real>;
  ISingle   = IValue<Single>;
  IDouble   = IValue<Double>;
  ICurrency = IValue<Currency>;

implementation

end.
