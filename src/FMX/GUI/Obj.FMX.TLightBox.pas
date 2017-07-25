unit Obj.FMX.TLightBox;

interface

uses
    FMX.Objects
  , FMX.Forms
  ;

type
  TLightBox = class(TRectangle)
  public
    constructor Create(const AParent: TCustomForm; const Opacity: Single = 0.8); overload;
  end;

implementation

uses
    FMX.Graphics
  , System.UITypes
  ;

{ TLightBox }

constructor TLightBox.Create(const AParent: TCustomForm; const Opacity: Single = 0.8);
begin
  inherited Create(AParent);
  Self.Parent      := AParent;
  Self.Width       := AParent.Width;
  Self.Height      := AParent.Height;
  Self.Opacity     := Opacity;
  Self.Fill.Kind   := TBrushKind.Solid;
  Self.Fill.Color  := TAlphaColors.Black;
  Self.Stroke.Kind := TBrushKind.None;
end;


end.
