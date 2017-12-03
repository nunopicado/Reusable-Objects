(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IConstraint                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IError                                                   **)
(**                 IErrorList                                               **)
(**                 IConstraintResult                                        **)
(**                 IConstraint                                              **)
(**                 IConstraints                                             **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
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

unit RO.IConstraints;

interface

type
  IError = interface(IInvokable)
  ['{930FDA03-395A-4D1F-AB22-4BF17FCC10F3}']
    function ID: string;
    function FailMessage: string;
  end;

  IErrorList = interface(IInvokable)
  ['{73B086E5-50DE-4ACC-88FE-993D5879BB8A}']
    function Add(const Error: IError): IErrorList; overload;
    function Add(const ErrorList: IErrorList): IErrorList; overload;
    function Get(const Idx: Integer): IError;
    function Count: Integer;
    function Text: string;
    function Clear: IErrorList;
  end;

  IConstraintResult = interface(IInvokable)
  ['{1D911B69-6924-4DEE-9A74-A398B834A83A}']
    function Success: Boolean;
    function ErrorList: IErrorList;
  end;

  IConstraint = interface(IInvokable)
  ['{EE07EA23-B130-4712-B162-0798A3CBE825}']
    function Eval: IConstraintResult;
  end;

  IConstraints = interface(IInvokable)
  ['{2C565D2F-3C5C-46AB-AF93-2745CA083C75}']
    function Add(const Constraint: IConstraint): IConstraints;
    function Get(const Idx: Integer): IConstraint;
    function Count: Integer;
    function Eval: IConstraintResult;
  end;

implementation

end.
