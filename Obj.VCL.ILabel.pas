unit Obj.VCL.ILabel;

interface

uses
    Obj.SSI.GenericIntf, Controls, Vcl.StdCtrls;

type
    TILabel = Class(TLabel, I<TLabel>)
    public
      class function New(Parent: TWinControl; Left, Top: Integer): I<TLabel>;
      function Obj: TLabel;
    End;

implementation

{ TLabel }

class function TILabel.New(Parent: TWinControl; Left, Top: Integer): I<TLabel>;
begin
     Result            := inherited Create(nil);
     Result.Obj.Parent := Parent;
     Result.Obj.Left   := Left;
     Result.Obj.Top    := Top;
end;

function TILabel.Obj: TLabel;
begin
     Result := Self;
end;

end.
