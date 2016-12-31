(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISliderMsg                                               **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(** Classes       : TSliderMsg, implements ISliderMsg                        **)
(******************************************************************************)
(** Dependencies  : FMX                                                      **)
(******************************************************************************)
(** Description   : An FMX message pop-up, with lightbox and sliding in and  **)
(**                 out effects                                              **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**                 terms                                                    **)
(******************************************************************************)

unit Obj.FMX.ISliderMsg;

interface

uses
    Classes
  , FMX.Forms
  , FMX.Types
  , FMX.Objects
  , FMX.Effects
  , FMX.Ani
  , FMX.StdCtrls
  , FMX.Graphics
  ;

type
{$REGION 'HelperClassesInterface'}
    TDynamicFloatAnimation = Class(FMX.Ani.TFloatAnimation)
    private
      FNowCreated: Boolean;
    public
      constructor CreateNow(AOwner: TComponent; AParent: TFMXObject; PropertyName: String; StartValue: Single; StopValue: Single; OnFinish: TNotifyEvent=nil);
    End;

    TLightBox = Class(TRectangle)
    public
      constructor Create(AParent: TCustomForm; Opacity: Single=0.8); Overload;
    End;

    TShadowRectangle = Class(TRectangle)
    private
      FShadow: TShadowEffect;
    public
      destructor Destroy; Override;
      constructor Create(AParent: TCustomForm; X, Y, Width, Height, Radius: Single; StrokeKind: TBrushKind); Overload;
    End;

    TCenteredLabel = Class(TLabel)
    public
      constructor Create(AOwner: TComponent; AParent: TFMXObject; UpDnMargin, LfRiMargin: Single; Text: String); Overload;
    End;

    TButton = Class(FMX.StdCtrls.TButton)
    public
      constructor Create(AOwner: TComponent; AParent: TFMXObject; Caption: String; Height: Single; UpDnMargin, LfRiMargin: Single; OnClick: TNotifyEvent); Overload;
    End;
{$ENDREGION}

    ISliderMsg = Interface ['{FE0C3FD7-CCC4-4B48-88AD-90286B4E0BBA}']
      function Show: ISliderMsg;
      function Hide: ISliderMsg;
    End;

    TSliderMsg = Class(TComponent, ISliderMsg)
    strict private
      LightBox     : TRectangle;
      MsgBox       : TRectangle;
      Text         : TLabel;
      Button       : TButton;
      Shadow       : TShadowEffect;
      FOwner       : TComponent;
      FParent      : TCustomForm;
      FMsg         : String;
      FWidth       : Single;
      FHeight      : Single;
      FShowingX    : Single;
      FShowingY    : Single;
      FHiddenY     : Single;
      FOnHide      : TNotifyEvent;
    private
      constructor CreatePrivate(AOwner: TComponent; AParent: TCustomForm; Msg: String; Width, Height: Single; OnHide: TNotifyEvent=nil);
      procedure Click(Sender: TObject);
      procedure TearDown(Sender: TObject);
    procedure Setup;
    public
      constructor Create(AOwner: TComponent); Override;
      class function New(AOwner: TComponent; AParent: TCustomForm; Msg: String; Width, Height: Single; OnHide: TNotifyEvent=nil): ISliderMsg;
      function Show: ISliderMsg;
      function Hide: ISliderMsg;
    End;

implementation

uses
    SysUtils
  , System.UITypes
  ;

{ TSliderMsg }

procedure TSliderMsg.Click(Sender: TObject);
begin
     Hide;
end;

constructor TSliderMsg.Create(AOwner: TComponent);
begin
     raise Exception.Create('TSliderMsg was not meant to used without an interface. Use New instead.');
end;

constructor TSliderMsg.CreatePrivate(AOwner: TComponent; AParent: TCustomForm; Msg: String; Width, Height: Single; OnHide: TNotifyEvent=nil);
begin
     inherited Create(AOwner);

     FOwner    := AOwner;
     FParent   := AParent;
     FMsg      := Msg;
     FWidth    := Width;
     FHeight   := Height;
     FShowingX := Round((AParent.Width / 2) - (Width / 2));
     FShowingY := Round((AParent.Height / 2) - (Height / 2));
     FHiddenY  := -Height - 10;
     FOnHide   := OnHide;
end;

procedure TSliderMsg.TearDown(Sender: TObject);
begin
     Button.Free;
     Text.Free;
     MsgBox.Free;
     LightBox.Free;
end;

function TSliderMsg.Hide: ISliderMsg;
begin
     Result := Self;
     TDynamicFloatAnimation.CreateNow(FOwner, MsgBox, 'Position.X', MsgBox.Position.X, -MsgBox.Width-10);
     TDynamicFloatAnimation.CreateNow(FOwner, MsgBox, 'Position.Y', FShowingY, FHiddenY);
     TDynamicFloatAnimation.CreateNow(FOwner, LightBox, 'Opacity', 0.8, 0, TearDown);
     if Assigned(FOnHide)
        then FOnHide(FOwner);
end;

procedure TSliderMsg.Setup;
begin
     LightBox := TLightBox.Create(FParent, 0);
     MsgBox   := TShadowRectangle.Create(FParent, FShowingX, FHiddenY, FWidth, FHeight, 6, TBrushKind.None);
     Text     := TCenteredLabel.Create(FOwner, MsgBox, 10, 20, FMsg);
     Button   := TButton.Create(FOwner, MsgBox, 'OK', 35, 10, 20, Click);
end;

class function TSliderMsg.New(AOwner: TComponent; AParent: TCustomForm; Msg: String; Width, Height: Single; OnHide: TNotifyEvent=nil): ISliderMsg;
begin
     Result := CreatePrivate(AOwner, AParent, Msg, Width, Height, OnHide);
end;

function TSliderMsg.Show: ISliderMsg;
begin
     Result := Self;
     Setup;
     TDynamicFloatAnimation.CreateNow(FOwner, MsgBox, 'Position.Y', FHiddenY, FShowingY);
     TDynamicFloatAnimation.CreateNow(FOwner, LightBox, 'Opacity', 0, 0.8);
end;

{$REGION 'HelperClassesImplementation'}

{ THFloatAnimation }

constructor TDynamicFloatAnimation.CreateNow(AOwner: TComponent; AParent: TFMXObject;
  PropertyName: String; StartValue, StopValue: Single; OnFinish: TNotifyEvent);
begin
     inherited Create(AOwner);
     FNowCreated       := True;
     Self.Parent       := AParent;
     Self.PropertyName := PropertyName;
     Self.StartValue   := StartValue;
     Self.StopValue    := StopValue;
     Self.OnFinish     := OnFinish;
     Start;
end;

{ TLightBox }

constructor TLightBox.Create(AParent: TCustomForm; Opacity: Single=0.8);
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

{ TShadowRectangle }

constructor TShadowRectangle.Create(AParent: TCustomForm; X, Y, Width, Height,
  Radius: Single; StrokeKind: TBrushKind);
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

{ TCenteredLabel }

constructor TCenteredLabel.Create(AOwner: TComponent; AParent: TFMXObject;
  UpDnMargin, LfRiMargin: Single; Text: String);
begin
     inherited Create(AOwner);
     Self.Parent                 := AParent;
     Self.Margins.Top            := UpDnMargin;
     Self.Margins.Bottom         := UpDnMargin;
     Self.Margins.Left           := LfRiMargin;
     Self.Margins.Right          := LfRiMargin;
     Self.Align                  := TAlignLayout.Client;
     Self.TextSettings.HorzAlign := TTextAlign.Center;
     Self.TextSettings.VertAlign := TTextAlign.Center;
     Self.TextSettings.WordWrap  := True;
     Self.Text                   := Text;
end;

{ TButton }

constructor TButton.Create(AOwner: TComponent; AParent: TFMXObject;
  Caption: String; Height: Single; UpDnMargin, LfRiMargin: Single; OnClick: TNotifyEvent);
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

{$ENDREGION}

end.
