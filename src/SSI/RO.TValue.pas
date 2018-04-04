(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IValue                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TValue                                                   **)
(**                 TBoolean, TChar, TString, TByte, TWord, TLongWord,       **)
(**                 TInteger, TInt64, TReal, TSingle, TDouble                **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
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

unit RO.TValue;

interface

uses
    RO.IValue
  , SysUtils
  ;

type
  TValue<T> = class(TInterfacedObject, IValue<T>)
  private
    FValue: T;
    FActive: Boolean;
    FDefine: TFunc<T>;
    procedure DoDefine;
  public
    constructor Create(const Define: TFunc<T>);
    class function New(const Define: TFunc<T>): IValue<T>; overload;
    class function New(const Value: T): IValue<T>; overload;
    class function NewDelayed(const Define: TFunc<T>): IValue<T>;
    function Value: T;
    function Refresh: IValue<T>;
  end;

  TBoolean    = TValue<Boolean>;
  TChar       = TValue<Char>;
  TString     = TValue<string>;
  TByte       = TValue<Byte>;
  TWord       = TValue<Word>;
  TLongWord   = TValue<LongWord>;
  TInteger    = TValue<Integer>;
  TInt64      = TValue<Int64>;
  TReal       = TValue<Real>;
  TSingle     = TValue<Single>;
  TDouble     = TValue<Double>;

  {$IFDEF MSWINDOWS}
    TAnsiString = TValue<AnsiString>;
  {$ENDIF}


implementation

{ TValue<T> }

procedure TValue<T>.DoDefine;
begin
  FValue  := FDefine;
  FActive := True;
end;

class function TValue<T>.New(const Value: T): IValue<T>;
begin
  Result := Create(
    function: T
    begin
      Result := Value;
    end
  );
end;

class function TValue<T>.NewDelayed(const Define: TFunc<T>): IValue<T>;
begin
  Result := New(Define);
end;

function TValue<T>.Refresh: IValue<T>;
begin
  Result  := Self;
  FActive := False;
end;

class function TValue<T>.New(const Define: TFunc<T>): IValue<T>;
begin
  Result := Create(Define);
end;

constructor TValue<T>.Create(const Define: TFunc<T>);
begin
  FDefine := Define;
  FActive := False;
end;

function TValue<T>.Value: T;
begin
  if not FActive
    then DoDefine;
  Result := FValue;
end;

end.
