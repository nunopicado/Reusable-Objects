unit RO.TUUID;

interface

uses
    RO.IValue
  , SysUtils
  ;

type
  TUUID = class(TInterfacedObject, IString)
  private
    FGUID: IValue<TGUID>;
  public
    constructor Create; reintroduce;
    class function New: IString;
    function Value: string;
    function Refresh: IString;
  end;

implementation

uses
    RO.TValue
  ;

{ TUUID }

constructor TUUID.Create;
begin
  FGUID := TValue<TGUID>.New(
    function : TGUID
    begin
      CreateGUID(Result);
    end
  );
end;

class function TUUID.New: IString;
begin
  Result := Create;
end;

function TUUID.Refresh: IString;
begin
  Result := Self;
  FGUID.Refresh;
end;

function TUUID.Value: string;
begin
  Result :=
    GUIDToString(FGUID.Value)
      .Replace('{', '')
      .Replace('}', '');
end;

end.
