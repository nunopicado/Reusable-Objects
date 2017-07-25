unit Obj.SSI.Using;

interface

uses
    SysUtils
  ;

type
  TObj = class
  public
    class procedure Using<T: class, constructor>(O: T; Proc: TProc<T>); overload; static;
    class procedure Using<T: class, constructor>(Proc: TProc<T>); overload; static;
  end;

implementation

{ Obj }

class procedure TObj.Using<T>(O: T; Proc: TProc<T>);
begin
  try
    Proc(O);
  finally
    O.Free;
  end;
end;

class procedure TObj.Using<T>(Proc: TProc<T>);
begin
  Using<T>(T.Create, Proc);
end;

end.
