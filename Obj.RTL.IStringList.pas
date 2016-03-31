unit Obj.RTL.IStringList;

interface

uses
    Classes, Obj.SSI.GenericIntf;

type
    TIStringList = Class(TInterfacedObject, I<TStringList>)
    private
      FObj: TStringList;
    public
      constructor Create; Overload;
      destructor Destroy; Override;
      class function New: I<TStringList>;
      function Obj: TStringList;
    End;

implementation

{ TIStringList }

constructor TIStringList.Create;
begin
     inherited Create;
     FObj := TStringList.Create;
end;

destructor TIStringList.Destroy;
begin
     FObj.Free;
     inherited;
end;

class function TIStringList.New: I<TStringList>;
begin
     Result := Create;
end;

function TIStringList.Obj: TStringList;
begin
     Result := FObj;
end;

end.
