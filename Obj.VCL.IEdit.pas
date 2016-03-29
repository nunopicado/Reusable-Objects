unit Obj.VCL.IEdit;

interface

uses
    Obj.SSI.GenericIntf, Controls, VCL.StdCtrls;

type
    TIEdit = Class(TEdit, I<TEdit>)
    public
      class function New(Parent: TWinControl; Left, Top: Integer): I<TEdit>;
      function Obj: TEdit;
    End;

implementation

{ TLabel }

class function TIEdit.New(Parent: TWinControl; Left, Top: Integer): I<TEdit>;
begin
     Result            := inherited Create(nil);
     Result.Obj.Parent := Parent;
     Result.Obj.Left   := Left;
     Result.Obj.Top    := Top;
end;

function TIEdit.Obj: TEdit;
begin
     Result := Self;
end;

end.


