unit RO.VCL.THexColor;

interface

uses
    RO.VCL.IColor
  , RO.IValue
  , Graphics
  ;

type
  THexColor = class(TInterfacedObject, IColor)
  private
    FColor: IValue<TColor>;
  public
    constructor Create(const Color: string);
    class function New(const Color: string): IColor;
    function AsTColor: TColor;
  end;

implementation

uses
    Windows
  , SysUtils
  , RO.TValue
  ;

{ TColor }

function THexColor.AsTColor: TColor;
begin
  Result := FColor.Value;
end;

constructor THexColor.Create(const Color: string);
begin
  FColor := TValue<TColor>.New(
    function : TColor
      function ExtractHexValue(const HexValue: string; const Index: Byte): Integer; inline;
      const
        PartValueSize = 2;
      begin
        Result := Format('$%s', [Copy(HexValue, Index * PartValueSize - 1, PartValueSize)]).ToInteger;
      end;
    begin
      Result := RGB(
        ExtractHexValue(Color, 1),
        ExtractHexValue(Color, 2),
        ExtractHexValue(Color, 3)
      );
    end
  );
end;

class function THexColor.New(const Color: string): IColor;
begin
  Result := Create(Color);
end;

end.
