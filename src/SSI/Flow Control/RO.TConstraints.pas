(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IConstraint                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TGenericConstraint, TConstraints, TConstraintResult,     **)
(**                 TErrorList, TError                                       **)
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

unit RO.TConstraints;

interface

uses
    Classes
  , SysUtils
  , RO.IValue
  , RO.IConstraints
  ;

type
  TError = class(TInterfacedObject, IError)
  private
    FID: string;
    FFailMessage: string;
  public
    constructor Create(const ID, FailMessage: string);
    class function New(const ID, FailMessage: string): IError; overload;
    class function New(const ID, FailMessage: IString): IError; overload;
    function ID: string;
    function FailMessage: string;
  end;

  TErrorList = class(TInterfacedObject, IErrorList)
  private
    FList: IInterfaceList;
  public
    constructor Create; overload;
    constructor Create(const Error: IError); overload;
    constructor Create(const ErrorList: IErrorList); overload;
    class function New: IErrorList; overload;
    class function New(const Error: IError): IErrorList; overload;
    class function New(const ErrorList: IErrorList): IErrorList; overload;
    function Add(const Error: IError): IErrorList; overload;
    function Add(const ErrorList: IErrorList): IErrorList; overload;
    function Get(const Idx: Integer): IError;
    function Count: Integer;
    function Text: string;
    function Clear: IErrorList;
  end;

  TConstraintResult = class(TInterfacedObject, IConstraintResult)
  private
    FSuccess: Boolean;
    FErrorList: IValue<IErrorList>;
  public
    constructor Create(const Success: Boolean); overload;
    constructor Create(const Success: Boolean; const ErrorList: IErrorList); overload;
    class function New(const Success: Boolean): IConstraintResult; overload;
    class function New(const Success: Boolean; const ErrorList: IErrorList): IConstraintResult; overload;
    function Success: Boolean;
    function ErrorList: IErrorList;
  end;

  TConstraints = class(TInterfacedObject, IConstraints)
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
  end;

  TGenericConstraint<T> = class(TInterfacedObject, IConstraint)
  private
    FID: string;
    FFailMessage: string;
    FTest: TPredicate<T>;
    FValue: T;
  public
    constructor Create(const Value: T; const ID, FailMessage: string; const Test: TPredicate<T>);
    class function New(const Value: T; const ID, FailMessage: string; const Test: TPredicate<T>): IConstraint; overload;
    class function New(const Value: T; const ID, FailMessage: IString; const Test: TPredicate<T>): IConstraint; overload;
    function Eval: IConstraintResult;
  end;


implementation

uses
    RO.TValue
  ;

{ TConstraintResult }

constructor TConstraintResult.Create(const Success: Boolean; const ErrorList: IErrorList);
begin
  Create(Success);
  FErrorList := TValue<IErrorList>.New(
    ErrorList
  );
end;

constructor TConstraintResult.Create(const Success: Boolean);
begin
  FSuccess   := Success;
  FErrorList := TValue<IErrorList>.New(
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

constructor TError.Create(const ID, FailMessage: string);
begin
  FID          := ID;
  FFailMessage := FailMessage;
end;

function TError.ID: string;
begin
  Result := FID;
end;

class function TError.New(const ID, FailMessage: IString): IError;
begin
  Result := New(ID.Value, FailMessage.Value);
end;

function TError.FailMessage: string;
begin
  Result := FFailMessage;
end;

class function TError.New(const ID, FailMessage: string): IError;
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

function TErrorList.Text: string;
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

constructor TGenericConstraint<T>.Create(const Value: T; const ID, FailMessage: string; const Test: TPredicate<T>);
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

class function TGenericConstraint<T>.New(const Value: T; const ID,
  FailMessage: IString; const Test: TPredicate<T>): IConstraint;
begin
  Result := New(Value, ID.Value, FailMessage.Value, Test);
end;

class function TGenericConstraint<T>.New(const Value: T; const ID, FailMessage: string; const Test: TPredicate<T>): IConstraint;
begin
  Result := Create(Value, ID, FailMessage, Test);
end;

end.
