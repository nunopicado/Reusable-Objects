unit Obj.SSI.Using;

interface

uses
    SysUtils
  ;

type
  Using = class
  public
    class procedure New<T: class, constructor>(Obj: T; Action: TProc<T>); overload; static;
    class procedure New<T: class, constructor>(Action: TProc<T>); overload; static;
  end;

implementation

{ Obj }

class procedure Using.New<T>(Obj: T; Action: TProc<T>);
begin
  try
    Action(Obj);
  finally
    Obj.Free;
  end;
end;

class procedure Using.New<T>(Action: TProc<T>);
begin
  New<T>(T.Create, Action);
end;

end.
