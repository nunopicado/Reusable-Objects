(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : Using                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : Using                                                    **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Allows instantiating an object freeing it automatically  **)
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

unit RO.Using;

interface

uses
    SysUtils
  ;

type
  Using = class
  public
    class procedure New<T: class, constructor>(Obj: T; Action: TProc<T>); overload; static;
    class procedure New<T: class, constructor>(Action: TProc<T>); overload; static;
    class function New<T: class, constructor;TResult>(Obj: T; Action: TFunc<T, TResult>): TResult; overload; static;
    class function New<T: class, constructor;TResult>(Action: TFunc<T, TResult>): TResult; overload; static;
  end;

implementation

{ Using }

class procedure Using.New<T>(Obj: T; Action: TProc<T>);
begin
  try
    Action(Obj);
  finally
    Obj.Free;
  end;
end;

class function Using.New<T, TResult>(Obj: T; Action: TFunc<T, TResult>): TResult;
begin
  try
    Result := Action(Obj);
  finally
    Obj.Free;
  end;
end;

class function Using.New<T, TResult>(Action: TFunc<T, TResult>): TResult;
begin
  Result := New<T, TResult>(T.Create, Action);
end;

class procedure Using.New<T>(Action: TProc<T>);
begin
  New<T>(T.Create, Action);
end;

end.
