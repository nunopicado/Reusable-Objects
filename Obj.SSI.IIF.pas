(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IIF                                                      **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IIF                                                      **)
(** Classes       : TIF, implements IIF                                      **)
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

unit Obj.SSI.IIF;

interface

type
    IIF<T> = Interface ['{4EC97D4A-BF07-4309-BE24-784424D12529}']
      function Eval: T;
    End;

    TIF<T> = Class(TInterfacedObject, IIF<T>)
    strict private
      FValue: T;
      constructor Create(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T);
    public
      class function New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIF<T>;
      function Eval: T;
    End;

implementation

{ TIIF }

constructor TIF<T>.Create(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T);
begin
     if Condition
        then FValue := ValueIfTrue
        else FValue := ValueIfFalse;
end;

function TIF<T>.Eval: T;
begin
     Result := FValue;
end;

class function TIF<T>.New(const Condition: Boolean; const ValueIfTrue, ValueIfFalse: T): IIF<T>;
begin
     Result := Create(Condition, ValueIfTrue, ValueIfFalse);
end;

end.
