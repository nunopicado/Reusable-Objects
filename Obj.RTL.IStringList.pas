unit Obj.RTL.IStringList;

interface

uses
    Classes, Obj.SSI.GenericIntf;

type
    TIStringList = Class(TInterfacedObject, I<TStringList>)
    private
      FObj: TStringList;
    public
      constructor Create(Text: String); Overload;
      destructor Destroy; Override;
      class function New(Text: String): I<TStringList>;
      function Obj: TStringList;
    End;

implementation

{ TIStringList }

constructor TIStringList.Create(Text: String);
begin
     inherited Create;
     FObj      := TStringList.Create;
     FObj.Text := Text;
end;

destructor TIStringList.Destroy;
begin
     FObj.Free;
     inherited;
end;

class function TIStringList.New(Text: String): I<TStringList>;
begin
     Result := Create(Text);
end;

function TIStringList.Obj: TStringList;
begin
     Result := FObj;
end;

end.
