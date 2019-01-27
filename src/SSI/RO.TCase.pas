(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICase                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TCase                                                    **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring                                                   **)
(******************************************************************************)
(** Description   : Tests a reference value against a list and performs the  **)
(**                 correspondent action                                     **)
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

unit RO.TCase;

interface

uses
    RO.ICase
  , SysUtils
  , Spring.Collections
  ;

type
  TCase<T> = class(TInterfacedObject, ICase<T>)
  private
    FReferenceValue: T;
    FCases: IDictionary<T, TProc<T>>;
    FDefaultAction: TProc<T>;
  public
    constructor Create(const ReferenceValue: T); reintroduce;
    class function New(const ReferenceValue: T): ICase<T>;
    function SetupReferenceValue(const ReferenceValue: T): ICase<T>;
    function AddCase(const Value: T; const Action: TProc<T>): ICase<T>; overload;
    function AddCase(const Values: array of T; const Action: TProc<T>): ICase<T>; overload;
    function AddElse(const DefaultAction: TProc<T>): ICase<T>;
    function Perform: ICase<T>;
  end;

  ICaseFactory<T> = interface(IInvokable)
  ['{702F3836-529B-4DE3-9B0D-E20C7767C11D}']
    function New(const ReferenceValue: T): ICase<T>;
  end;

implementation

{ TCase<T> }

function TCase<T>.AddCase(const Value: T; const Action: TProc<T>): ICase<T>;
begin
  Result := Self;
  if FCases.ContainsKey(Value)
    then raise Exception.Create('Can not add a duplicate case for testing.');
  FCases.Add(Value, Action);
end;

function TCase<T>.AddCase(const Values: array of T; const Action: TProc<T>): ICase<T>;
var
  i: Integer;
begin
  Result := Self;
  for i := Low(Values) to High(Values) do
    AddCase(Values[i], Action);
end;

function TCase<T>.AddElse(const DefaultAction: TProc<T>): ICase<T>;
begin
  Result          := Self;
  FDefaultAction  := DefaultAction;
end;

constructor TCase<T>.Create(const ReferenceValue: T);
begin
  FCases := TCollections.CreateDictionary<T, TProc<T>>;
  SetupReferenceValue(ReferenceValue);
end;

function TCase<T>.Perform: ICase<T>;
var
  Action: TProc<T>;
begin
  Result := Self;
  if FCases.ContainsKey(FReferenceValue)
    then Action := FCases.Extract(FReferenceValue)
    else Action := FDefaultAction;
  if Assigned(Action)
    then Action(FReferenceValue);
end;

function TCase<T>.SetupReferenceValue(const ReferenceValue: T): ICase<T>;
begin
  Result          := Self;
  FReferenceValue := ReferenceValue;
end;

class function TCase<T>.New(const ReferenceValue: T): ICase<T>;
begin
  Result := Create(ReferenceValue);
end;

end.
