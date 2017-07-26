unit Obj.SSI.TConstraints;

interface

uses
    Classes
  , Obj.SSI.IValue
  , Obj.SSI.IConstraints
  ;

type
  TError = Class(TInterfacedObject, IError)
  private
    FID: String;
    FFailMessage: String;
  public
    constructor Create(const ID, FailMessage: String);
    class function New(const ID, FailMessage: String): IError;
    function ID: String;
    function FailMessage: String;
  End;

  TErrorList = Class(TInterfacedObject, IErrorList)
  private
    FList: IInterfaceList;
  public
    constructor Create; Overload;
    constructor Create(const Error: IError); Overload;
    constructor Create(const ErrorList: IErrorList); Overload;
    class function New: IErrorList; Overload;
    class function New(const Error: IError): IErrorList; Overload;
    class function New(const ErrorList: IErrorList): IErrorList; Overload;
    function Add(const Error: IError): IErrorList; Overload;
    function Add(const ErrorList: IErrorList): IErrorList; Overload;
    function Get(const Idx: Integer): IError;
    function Count: Integer;
    function Text: String;
    function Clear: IErrorList;
  End;

  TConstraintResult = Class(TInterfacedObject, IConstraintResult)
  private
    FSuccess: Boolean;
    FErrorList: IValue<IErrorList>;
  public
    constructor Create(const Success: Boolean); Overload;
    constructor Create(const Success: Boolean; const ErrorList: IErrorList); Overload;
    class function New(const Success: Boolean): IConstraintResult; Overload;
    class function New(const Success: Boolean; const ErrorList: IErrorList): IConstraintResult; Overload;
    function Success: Boolean;
    function ErrorList: IErrorList;
  End;

  TConstraints = Class(TInterfacedObject, IConstraints)
  private
    FList: IInterfaceList;
    FValid: Boolean;
    FErrorList: IErrorList;
    procedure MergeContraintResults;
  public
    constructor Create(const Constraint: IConstraint);
    class function New(const Constraint: IConstraint): IConstraints;
    function Add(const Constraint: IConstraint): IConstraints;
    function Get(const Idx: Integer): IConstraint;
    function Count: Integer;
    function Eval: IConstraintResult;
  End;

  TBooleanFunction<T> = Reference to Function(Value: T): Boolean;
  TGenericConstraint<T> = Class(TInterfacedObject, IConstraint)
  private
    FID: String;
    FFailMessage: String;
    FTest: TBooleanFunction<T>;
    FValue: T;
  public
    constructor Create(const Value: T; const ID, FailMessage: String; const Test: TBooleanFunction<T>);
    class function New(const Value: T; const ID, FailMessage: String; const Test: TBooleanFunction<T>): IConstraint;
    function Eval: IConstraintResult;
  End;


implementation

uses
    SysUtils
  , Obj.SSI.TCached
  ;

{ TConstraintResult }

constructor TConstraintResult.Create(const Success: Boolean; const ErrorList: IErrorList);
begin
  Create(Success);
  FErrorList := TCached<IErrorList>.New(
    ErrorList
  );
end;

constructor TConstraintResult.Create(const Success: Boolean);
begin
  FSuccess   := Success;
  FErrorList := TCached<IErrorList>.New(
    function : IErrorList
    begin
      Result := TErrorList.New;
    end
  );
end;

function TConstraintResult.ErrorList: IErrorList;
begin
  Result := FErrorList.Value;
end;

class function TConstraintResult.New(const Success: Boolean): IConstraintResult;
begin
  Result := Create(Success);
end;

class function TConstraintResult.New(const Success: Boolean; const ErrorList: IErrorList): IConstraintResult;
begin
  Result := Create(Success, ErrorList);
end;

function TConstraintResult.Success: Boolean;
begin
  Result := FSuccess;
end;

{ TConstraints }

function TConstraints.Add(const Constraint: IConstraint): IConstraints;
begin
  Result := Self;
  FList.Add(Constraint);
end;

function TConstraints.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TConstraints.Create(const Constraint: IConstraint);
begin
  FList      := TInterfaceList.Create;
  FValid     := True;
  FErrorList := TErrorList.New;
  FList.Add(Constraint);
end;

function TConstraints.Eval: IConstraintResult;
begin
  MergeContraintResults;
  Result := TConstraintResult.New(
    FValid,
    FErrorList
  );
end;

procedure TConstraints.MergeContraintResults;
var
  Idx: Integer;
begin
  FErrorList.Clear;
  for Idx := 0 to Pred(FList.Count) do
    with IConstraint(FList.Items[Idx]).Eval do
    begin
      FValid := FValid and Success;
      FErrorList.Add(ErrorList);
    end;
end;

function TConstraints.Get(const Idx: Integer): IConstraint;
begin
  Result := IConstraint(FList.Items[Idx]);
end;

class function TConstraints.New(const Constraint: IConstraint): IConstraints;
begin
  Result := Create(Constraint);
end;

{ TError }

constructor TError.Create(const ID, FailMessage: String);
begin
  FID          := ID;
  FFailMessage := FailMessage;
end;

function TError.ID: String;
begin
  Result := FID;
end;

function TError.FailMessage: String;
begin
  Result := FFailMessage;
end;

class function TError.New(const ID, FailMessage: String): IError;
begin
  Result := Create(ID, FailMessage);
end;

{ TErrorList }

function TErrorList.Add(const ErrorList: IErrorList): IErrorList;
var
  Idx: Integer;
begin
  for Idx := 0 to Pred(ErrorList.Count) do
    Add(ErrorList.Get(Idx));
end;

function TErrorList.Add(const Error: IError): IErrorList;
begin
  Result := Self;
  FList.Add(Error);
end;

function TErrorList.Clear: IErrorList;
begin
  Result := Self;
  FList.Clear;
end;

function TErrorList.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TErrorList.Create(const ErrorList: IErrorList);
var
  Idx: Integer;
begin
  Create;
  for Idx := 0 to Pred(ErrorList.Count) do
    FList.Add(ErrorList.Get(Idx));
end;

constructor TErrorList.Create;
begin
  FList := TInterfaceList.Create;
end;

constructor TErrorList.Create(const Error: IError);
begin
  Create;
  FList.Add(Error);
end;

function TErrorList.Get(const Idx: Integer): IError;
begin
  Result := IError(FList.Items[Idx]);
end;

class function TErrorList.New: IErrorList;
begin
  Result := Create;
end;

class function TErrorList.New(const Error: IError): IErrorList;
begin
  Result := Create(Error);
end;

class function TErrorList.New(const ErrorList: IErrorList): IErrorList;
begin
  Result := Create(ErrorList);
end;

function TErrorList.Text: String;
var
  Idx: Integer;
begin
  for Idx := 0 to Pred(Count) do
    with IError(FList.Items[Idx]) do
      begin
        if Idx > 0
          then Result := Result + #13#10;
        Result := Result + Format('%s: %s', [ID, FailMessage]);
      end;
end;

{ TGenericConstraint<T> }

constructor TGenericConstraint<T>.Create(const Value: T; const ID, FailMessage: String; const Test: TBooleanFunction<T>);
begin
  FValue       := Value;
  FID          := ID;
  FFailMessage := FailMessage;
  FTest        := Test;
end;

function TGenericConstraint<T>.Eval: IConstraintResult;
var
  OK: Boolean;
begin
  OK := FTest(FValue);
  if OK
    then Result := TConstraintResult.New(OK)
    else Result := TConstraintResult.New(
           OK,
           TErrorList.New(
             TError.New(
               FID,
               FFailMessage
             )
           )
         );
end;

class function TGenericConstraint<T>.New(const Value: T; const ID, FailMessage: String; const Test: TBooleanFunction<T>): IConstraint;
begin
  Result := Create(Value, ID, FailMessage, Test);
end;

end.
