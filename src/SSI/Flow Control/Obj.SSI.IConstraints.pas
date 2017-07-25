unit Obj.SSI.IConstraints;

interface

type
  IError = Interface
  ['{930FDA03-395A-4D1F-AB22-4BF17FCC10F3}']
    function ID: String;
    function FailMessage: String;
  End;

  IErrorList = Interface
  ['{73B086E5-50DE-4ACC-88FE-993D5879BB8A}']
    function Add(const Error: IError): IErrorList; Overload;
    function Add(const ErrorList: IErrorList): IErrorList; Overload;
    function Get(const Idx: Integer): IError;
    function Count: Integer;
    function Text: String;
    function Clear: IErrorList;
  End;

  IConstraintResult = Interface
  ['{1D911B69-6924-4DEE-9A74-A398B834A83A}']
    function Success: Boolean;
    function ErrorList: IErrorList;
  End;

  IConstraint = Interface
  ['{EE07EA23-B130-4712-B162-0798A3CBE825}']
    function Eval: IConstraintResult;
  End;

  IConstraints = Interface
  ['{2C565D2F-3C5C-46AB-AF93-2745CA083C75}']
    function Add(const Constraint: IConstraint): IConstraints;
    function Get(const Idx: Integer): IConstraint;
    function Count: Integer;
    function Eval: IConstraintResult;
  end;

implementation

end.
