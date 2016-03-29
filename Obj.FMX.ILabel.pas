unit Obj.FMX.ILabel;

interface

uses
    Obj.SSI.GenericIntf, FMX.Types, FMX.StdCtrls;

type
    TILabel = Class(TLabel, I<TLabel>)
    public
      class function New(Parent: TFMXObject; Left, Top: Integer): I<TLabel>;
      function Obj: TLabel;
    End;

implementation

{ TLabel }

class function TILabel.New(Parent: TFMXObject; Left, Top: Integer): I<TLabel>;
begin
     Result                := inherited Create(nil);
     Result.Obj.Parent     := Parent;
     Result.Obj.Position.X := Left;
     Result.Obj.Position.Y := Top;
end;

function TILabel.Obj: TLabel;
begin
     Result := Self;
end;

end.

