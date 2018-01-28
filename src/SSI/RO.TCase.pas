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
    FCases: IDictionary<T, TProc>;
    FDefaultAction: TProc;
  public
    constructor Create(const ReferenceValue: T); reintroduce;
    class function New(const ReferenceValue: T): ICase<T>;
    function SetupReferenceValue(const ReferenceValue: T): ICase<T>;
    function AddCase(const Value: T; const Action: TProc): ICase<T>;
    function AddElse(const DefaultAction: TProc): ICase<T>;
    function Perform: ICase<T>;
  end;

implementation

{ TCase<T> }

function TCase<T>.AddCase(const Value: T; const Action: TProc): ICase<T>;
begin
  Result := Self;
  if FCases.ContainsKey(Value)
    then raise Exception.Create('Can not add a duplicate case for testing.');
  FCases.AddOrSetValue(Value, Action);
end;

function TCase<T>.AddElse(const DefaultAction: TProc): ICase<T>;
begin
  Result          := Self;
  FDefaultAction  := DefaultAction;
end;

constructor TCase<T>.Create(const ReferenceValue: T);
begin
  FCases := TCollections.CreateDictionary<T, TProc>;
  SetupReferenceValue(ReferenceValue);
end;

function TCase<T>.Perform: ICase<T>;
var
  Action: TProc;
begin
  Result := Self;
  if FCases.ContainsKey(FReferenceValue)
    then Action := FCases.Extract(FReferenceValue)
    else Action := FDefaultAction;
  if Assigned(Action)
    then Action();
end;

function TCase<T>.SetupReferenceValue(const ReferenceValue: T): ICase<T>;
begin
  FReferenceValue := ReferenceValue;
end;

class function TCase<T>.New(const ReferenceValue: T): ICase<T>;
begin
  Result := Create(ReferenceValue);
end;

end.
