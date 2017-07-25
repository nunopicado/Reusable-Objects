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

unit Obj.FMX.TSliderMsg;

interface

uses
    Classes
  , FMX.Forms
  , FMX.Objects
  , FMX.Effects
  , FMX.StdCtrls
  , FMX.Graphics
  , Obj.FMX.ISliderMsg
  ;

type
  TSliderMsg = class(TComponent, ISliderMsg)
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
    constructor CreatePrivate(const AOwner: TComponent; const AParent: TCustomForm; const Msg: String;
                              const Width, Height: Single; const OnHide: TNotifyEvent=nil);
    procedure Click(Sender: TObject);
    procedure TearDown(Sender: TObject);
    procedure Setup;
  public
    constructor Create(AOwner: TComponent); Override;
    class function New(AOwner: TComponent; AParent: TCustomForm; Msg: String; Width, Height: Single; OnHide: TNotifyEvent=nil): ISliderMsg;
    function Show: ISliderMsg;
    function Hide: ISliderMsg;
  end;

implementation

uses
    SysUtils
  , FMX.Types
  , FMX.Ani.Ext
  , FMX.StdCtrls.Ext
  , Obj.FMX.TLightBox
  , Obj.FMX.TShadowRectangle
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

constructor TSliderMsg.CreatePrivate(const AOwner: TComponent; const AParent: TCustomForm; const Msg: String;
 const Width, Height: Single; const OnHide: TNotifyEvent = nil);
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
  TFloatAnimation.Create(FOwner, MsgBox, 'Position.X', MsgBox.Position.X, -MsgBox.Width-10);
  TFloatAnimation.Create(FOwner, MsgBox, 'Position.Y', FShowingY, FHiddenY);
  TFloatAnimation.Create(FOwner, LightBox, 'Opacity', 0.8, 0, TearDown);
  if Assigned(FOnHide)
    then FOnHide(FOwner);
end;

procedure TSliderMsg.Setup;
begin
  LightBox := TLightBox.Create(FParent, 0);
  MsgBox   := TShadowRectangle.Create(FParent, FShowingX, FHiddenY, FWidth, FHeight, 6, TBrushKind.None);
  Text     := TLabel.Create(FOwner, MsgBox, 10, 20, FMsg, TTextAlign.Center);
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
  TFloatAnimation.Create(FOwner, MsgBox, 'Position.Y', FHiddenY, FShowingY);
  TFloatAnimation.Create(FOwner, LightBox, 'Opacity', 0, 0.8);
end;

end.
