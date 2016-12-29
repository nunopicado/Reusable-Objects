(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMaybe                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(** Forked by     : Igor Nunes                                               **)
(******************************************************************************)
(** Interfaces    : IMaybe                                                   **)
(** Classes       : TMaybe, Implements IMaybe                                **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Represents a value than may or may not be defined        **)
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

unit Obj.SSI.IMaybe;

interface

type
  TMaybeEnum = (Nothing, JustT);

  IMaybe<T> = Interface
    function Define(value : T) : IMaybe<T>;
    function LookUp : TMaybeEnum;
    function Value : T;
  End;

  TMaybe<T> = Class(TInterfacedObject, IMaybe<T>)
  private
    FValue : T;
    FResult : TMaybeEnum;
  public
    class function New : IMaybe<T>;
    function Define(value : T) : IMaybe<T>;
    function LookUp : TMaybeEnum;
    function Value : T;
  End;

implementation
uses
  SysUtils;

function TMaybe<T>.Define(value : T) : IMaybe<T>;
begin
  Result   := self;
  FValue   := value;
  FResult  := JustT;
end;

function TMaybe<T>.LookUp : TMaybeEnum;
begin
  LookUp := FResult;
end;

class function TMaybe<T>.New : IMaybe<T>;
begin
  New := Create;
end;

function TMaybe<T>.value : T;
begin
  case self.FResult of
    JustT   : value := FValue;
    nothing : raise Exception.Create('Maybe<T>: there is literally nothing here!');
  end;
end;

end.
