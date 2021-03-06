(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IIf                                                      **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TIf                                                      **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
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

unit RO.TIf;

interface

uses
    RO.IIf
  ;

type
  TIf<T> = class(TInterfacedObject, IIf<T>)
  strict private
    FValue: T;
    constructor Create(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T);
  public
    class function New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIf<T>;
    function Eval: T;
  end;

implementation

{ TIf }

constructor TIf<T>.Create(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T);
begin
  if Condition
    then FValue := ValueIfTrue
    else FValue := ValueIfFalse;
end;

function TIf<T>.Eval: T;
begin
  Result := FValue;
end;

class function TIf<T>.New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIf<T>;
begin
  Result := Create(
    Condition,
    ValueIfTrue,
    ValueIfFalse
  );
end;

end.
