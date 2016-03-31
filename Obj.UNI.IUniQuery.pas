unit Obj.UNI.IUniQuery;

interface

uses
    Obj.SSI.GenericIntf, Uni;

type
    I<T> = Interface (Obj.SSI.GenericIntf.I<T>) ['{F7928CA1-6E47-400E-9BC4-DEAEB1E72AC6}']
      function Run(const Params: Array of Variant): I<TUniQuery>; Overload;
      function Run: I<TUniQuery>; Overload;
      function SQL(const SQLStatement: String): I<TUniQuery>;
    End;

    TIUniQuery = Class(TInterfacedObject, I<TUniQuery>)
    private
      FObj: TUniQuery;
    public
      constructor Create(aConnection: TUniConnection); Overload;
      destructor Destroy; Override;
      class function New(aConnection: TUniConnection; const SQLStatement: String): I<TUniQuery>; Overload;
      class function New(aConnection: TUniConnection): I<TUniQuery>; Overload;
      function Run(const Params: Array of Variant): I<TUniQuery>; Overload;
      function Run: I<TUniQuery>; Overload;
      function SQL(const SQLStatement: String): I<TUniQuery>;
      function Obj: TUniQuery;
    End;

implementation

{ TIUniQuery }

constructor TIUniQuery.Create(aConnection: TUniConnection);
begin
     if (not Assigned(aConnection)) or (not aConnection.Connected)
        then raise ESSIError.CreateFmt('Cannot access database!%sConnection ''%s'' unavailable or offline.',[#10,aConnection.Name]);

     inherited Create;
     FObj                       := TUniQuery.Create(nil);
     FObj.Connection            := aConnection;
     FObj.Options.QueryRecCount := True;
end;

destructor TIUniQuery.Destroy;
begin
     FObj.Free;
     inherited;
end;

class function TIUniQuery.New(aConnection: TUniConnection): I<TUniQuery>;
begin
     Result := Create(aConnection);
end;

class function TIUniQuery.New(aConnection: TUniConnection; const SQLStatement: String): I<TUniQuery>;
begin
     Result := Create(aConnection).SQL(SQLStatement);
end;

function TIUniQuery.Obj: TUniQuery;
begin
     Result := FObj;
end;

function TIUniQuery.Run: I<TUniQuery>;
begin
     Result := Run([]);
end;

function TIUniQuery.SQL(const SQLStatement: String): I<TUniQuery>;
begin
     Result := Self;

     if SQLStatement=''
        then raise ESSIError.Create('Cannot run an empty query!');

     FObj.SQL.Text := SQLStatement;
end;

function TIUniQuery.Run(const Params: array of Variant): I<TUniQuery>;
var
   Param: Integer;
begin
     Result := Self;

     if Odd(Length(Params))
        then raise ESSIError.CreateFmt('Invalid parameter list!%sOdd parameter number in SQL Statement',[#10]);

     Param := 0;
     while Param < Length(Params) do
           begin
                FObj.ParamByName(Params[Param]).Value := Params[Param + 1];
                Inc(Param, 2);
           end;
     FObj.Open;
end;

end.
