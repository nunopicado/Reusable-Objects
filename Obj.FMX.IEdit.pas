unit Obj.FMX.IEdit;

interface

uses
    Obj.SSI.GenericIntf, FMX.Types, FMX.Edit;

type
    TIEdit = Class(TEdit, I<TEdit>)
    public
      class function New(Parent: TFMXObject; Left, Top: Integer): I<TEdit>;
      function Obj: TEdit;
    End;

implementation

{ TLabel }

class function TIEdit.New(Parent: TFMXObject; Left, Top: Integer): I<TEdit>;
begin
     Result                := inherited Create(nil);
     Result.Obj.Parent     := Parent;
     Result.Obj.Position.X := Left;
     Result.Obj.Position.Y := Top;
end;

function TIEdit.Obj: TEdit;
begin
     Result := Self;
end;

end.

