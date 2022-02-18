unit RO.TMaybe;

interface

uses
    RO.IMaybe
  , RO.IValue
  ;

type
  TMaybe<T> = class(TInterfacedObject, IMaybe<T>)
  private
    FValue  : T;
    FSet    : Boolean;
  public
    constructor Create; overload;
    constructor Create(const Value: T; const Condition: Boolean = True); overload;
    class function New: IMaybe<T>; overload;
    class function New(const Value: T; const Condition: Boolean = True): IMaybe<T>; overload;
    function IsSet: Boolean;
    function Value: T;
  end;

implementation

uses
    RO.TValue
  ;

{ TMaybe<T> }

constructor TMaybe<T>.Create;
begin
  FSet := False;
end;

constructor TMaybe<T>.Create(const Value: T; const Condition: Boolean = True);
begin
  FSet  := Condition;
  if FSet
    then FValue := Value;
end;

function TMaybe<T>.IsSet: Boolean;
begin
  Result := FSet;
end;

class function TMaybe<T>.New: IMaybe<T>;
begin
  Result := Create;
end;

class function TMaybe<T>.New(const Value: T; const Condition: Boolean): IMaybe<T>;
begin
  Result := Create(Value, Condition);
end;

function TMaybe<T>.Value: T;
begin
  Result := FValue;
end;

end.
