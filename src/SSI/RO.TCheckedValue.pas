(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICheckedValue<T>                                         **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TCheckedValue<T>                                         **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Extends TValue<T> with support for ICheckedValue<T>      **)
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

unit RO.TCheckedValue;

interface

uses
    RO.ICheckedValue
  , RO.IValue
  ;

type
  TCheckedValue<T> = class(TInterfacedObject, ICheckedValue<T>, IValue<T>)
  private
    FValue: IValue<T>;
    FChecked: Boolean;
  public
    constructor Create(const Value: IValue<T>; const Checked: Boolean);
    class function New(const Value: IValue<T>; const Checked: Boolean): ICheckedValue<T>; overload;
    class function New(const Value: T; const Checked: Boolean): ICheckedValue<T>; overload;
    function Value: T;
    function Refresh: IValue<T>;
    function Checked: Boolean;
    function Swap: ICheckedValue<T>;
  end;

implementation

uses
    RO.TValue
  ;

{ TCheckedValue<T> }

function TCheckedValue<T>.Checked: Boolean;
begin
  Result := FChecked;
end;

constructor TCheckedValue<T>.Create(const Value: IValue<T>; const Checked: Boolean);
begin
  FValue    := Value;
  FChecked  := Checked;
end;

class function TCheckedValue<T>.New(const Value: IValue<T>; const Checked: Boolean): ICheckedValue<T>;
begin
  Result := Create(Value, Checked);
end;

class function TCheckedValue<T>.New(const Value: T; const Checked: Boolean): ICheckedValue<T>;
begin
  Result := Create(
    TValue<T>.New(Value),
    Checked
  );
end;

function TCheckedValue<T>.Refresh: IValue<T>;
begin
  Result := Self;
  FValue.Refresh;
end;

function TCheckedValue<T>.Swap: ICheckedValue<T>;
begin
  Result    := Self;
  FChecked  := not FChecked;
end;

function TCheckedValue<T>.Value: T;
begin
  Result := FValue.Value;
end;

end.
