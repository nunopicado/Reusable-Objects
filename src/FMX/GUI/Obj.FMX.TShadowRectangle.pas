unit Obj.FMX.TShadowRectangle;

interface

uses
    FMX.Objects
  , FMX.Graphics
  , FMX.Forms
  , FMX.Effects
  ;

type
  TShadowRectangle = class(TRectangle)
  private
    FShadow: TShadowEffect;
  public
    destructor Destroy; override;
    constructor Create(const AParent: TCustomForm; const X, Y, Width, Height, Radius: Single;
                       const StrokeKind: TBrushKind); overload;
  end;

implementation

{ TShadowRectangle }

constructor TShadowRectangle.Create(const AParent: TCustomForm; const X, Y, Width, Height,
  Radius: Single; const StrokeKind: TBrushKind);
begin
  inherited Create(AParent);
  Self.Parent     := AParent;
  Self.Position.X := X;
  Self.Position.Y := Y;
  Self.Width      := Width;
  Self.Height     := Height;
  Self.XRadius    := Radius;
  Self.YRadius    := Radius;

  FShadow        := TShadowEffect.Create(AParent);
  FShadow.Parent := Self;
end;

destructor TShadowRectangle.Destroy;
begin
  FShadow.Free;
  inherited;
end;

end.
