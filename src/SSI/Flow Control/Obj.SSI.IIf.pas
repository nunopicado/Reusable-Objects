(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IIf                                                      **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IIf                                                      **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Allows using an IF statement inside an expression        **)
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

unit Obj.SSI.IIf;

interface

type
  {$M+}
  IIf<T> = interface
  ['{4EC97D4A-BF07-4309-BE24-784424D12529}']
    function Eval: T;
  End;

  IIfFactory<T> = interface
  ['{8D8FA9F1-A9C1-4182-9117-A402FE966F28}']
    function New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIf<T>;
  end;
  {$M-}

implementation

end.
