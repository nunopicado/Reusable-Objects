unit Obj.UNI.IUniQuery;

interface

uses
    Obj.SSI.GenericIntf, Uni;

type
    I<T> = Interface (Obj.SSI.GenericIntf.I<T>) ['{F7928CA1-6E47-400E-9BC4-DEAEB1E72AC6}']
    End;

    TIUniQuery = Class(TInterfacedObject, I<TUniQuery>)
    private
      FObj: TUniQuery;
    public
      constructor Create(aConnection: TUniConnection; SQL: String; Params: Array of Variant); Overload;
      class function New(aConnection: TUniConnection; SQL: String; Params: Array of Variant): I<TUniQuery>; Overload;
      class function New(aConnection: TUniConnection; SQL: String): I<TUniQuery>; Overload;
      function Obj: TUniQuery;
    End;

implementation

{ TIUniQuery }

constructor TIUniQuery.Create(aConnection: TUniConnection; SQL: String; Params: Array of Variant);
var
   p: Integer;
begin
     if (not Assigned(aConnection)) or (not aConnection.Connected) or (SQL='')
        then Exit;

     inherited Create;
     FObj                       := TUniQuery.Create(nil);
     FObj.Connection            := aConnection;
     FObj.Options.QueryRecCount := True;

     if Length(Params)>0
        then begin
                  p := 0;
                  repeat
                        ParamByName(String(Params[p])).Value := Params[p+1];
                        Inc(p,2);
                  until p >= High(Params)-1;
             end;
     Self.Open;
destructor TIUniQuery.Destroy;
begin
     FObj.Free;
     inherited;
end;

class function TIUniQuery.New(aConnection: TUniConnection; SQL: String; Params: Array of Variant): I<TUniQuery>;
begin
     Result := Create(aConnection, SQL, Params);
end;

class function TIUniQuery.New(aConnection: TUniConnection; SQL: String): I<TUniQuery>;
begin
     Result := Create(aConnection, SQL, []);
end;

function TIUniQuery.Obj: TUniQuery;
begin
     Result := FObj;
end;

     Result := Self;
end;

end.
