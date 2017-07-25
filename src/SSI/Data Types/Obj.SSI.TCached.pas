(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICached                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICached                                                  **)
(** Classes       : TCached, Implements ICached                              **)
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

unit Obj.SSI.TCached;

interface

uses
    Obj.SSI.ICached
  ;

type
  TCached<T> = Class(TInterfacedObject, ICached<T>)
  private
    FValue: T;
    FActive: Boolean;
    FDefine: TDefineCached<T>;
    procedure DoDefine;
  public
    constructor Create(const Define: TDefineCached<T>);
    class function New(const Define: TDefineCached<T>): ICached<T>; overload;
    class function New(const Value: T): ICached<T>; overload;
    function Value: T;
  End;

  TCachedBoolean  = TCached<Boolean>;
  TCachedChar     = TCached<Char>;
  TCachedString   = TCached<String>;
  TCachedByte     = TCached<Byte>;
  TCachedWord     = TCached<Word>;
  TCachedLongWord = TCached<LongWord>;
  TCachedInteger  = TCached<Integer>;
  TCachedInt64    = TCached<Int64>;
  TCachedReal     = TCached<Real>;
  TCachedSingle   = TCached<Single>;
  TCachedDouble   = TCached<Double>;
  TCachedCurrency = TCached<Currency>;

implementation

uses
    SysUtils
  ;

{ TCached<T> }

procedure TCached<T>.DoDefine;
begin
  FValue  := FDefine;
  FActive := True;
end;

class function TCached<T>.New(const Value: T): ICached<T>;
begin
  Result := Create(
    function: T
    begin
      Result := Value;
    end
  );
end;

class function TCached<T>.New(const Define: TDefineCached<T>): ICached<T>;
begin
  Result := Create(Define);
end;

constructor TCached<T>.Create(const Define: TDefineCached<T>);
begin
  FDefine := Define;
  FActive := False;
end;

function TCached<T>.Value: T;
begin
  if not FActive
    then DoDefine;
  Result := FValue;
end;

end.
