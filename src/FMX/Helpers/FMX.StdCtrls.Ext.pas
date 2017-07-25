unit FMX.StdCtrls.Ext;

interface

uses
    Classes
  , FMX.Types
  , FMX.StdCtrls
  ;

type
  TButton = class(FMX.StdCtrls.TButton)
  public
    constructor Create(const AOwner: TComponent; const AParent: TFMXObject; const Caption: string; const Height: Single;
                       const UpDnMargin, LfRiMargin: Single; const OnClick: TNotifyEvent); overload;
  end;

  TLabel = class(FMX.StdCtrls.TLabel)
  public
    constructor Create(const AOwner: TComponent; const AParent: TFMXObject; const UpDnMargin, LfRiMargin: Single;
                       const Text: String; const TextAlign: TTextAlign); overload;
  end;

implementation

{ TButton }

constructor TButton.Create(const AOwner: TComponent; const AParent: TFMXObject; const  Caption: String;
 const Height: Single; const UpDnMargin, LfRiMargin: Single; const OnClick: TNotifyEvent);
begin
  inherited Create(AOwner);
  Self.Parent         := AParent;
  Self.Align          := TAlignLayout.Bottom;
  Self.Text           := Caption;
  Self.Height         := Height;
  Self.Margins.Top    := UpDnMargin;
  Self.Margins.Bottom := UpDnMargin;
  Self.Margins.Left   := LfRiMargin;
  Self.Margins.Right  := LfRiMargin;
  Self.OnClick        := OnClick;
end;

{ TCenteredLabel }

constructor TLabel.Create(const AOwner: TComponent; const AParent: TFMXObject;
 const UpDnMargin, LfRiMargin: Single; const Text: String; const TextAlign: TTextAlign);
begin
  inherited Create(AOwner);
  Self.Parent                 := AParent;
  Self.Margins.Top            := UpDnMargin;
  Self.Margins.Bottom         := UpDnMargin;
  Self.Margins.Left           := LfRiMargin;
  Self.Margins.Right          := LfRiMargin;
  Self.Align                  := TAlignLayout.Client;
  Self.TextSettings.HorzAlign := TextAlign;
  Self.TextSettings.VertAlign := TextAlign;
  Self.TextSettings.WordWrap  := True;
  Self.Text                   := Text;
end;

end.
