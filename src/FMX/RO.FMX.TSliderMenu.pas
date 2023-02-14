(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISliderMenu                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TSliderMenu                                              **)
(**                 TSliderMenuItem                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : FMX                                                      **)
(******************************************************************************)
(** Description   : A menu that slides from the left side and hides back     **)
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

unit RO.FMX.TSliderMenu;

interface

uses
    RO.ISliderMenu
  , FMX.Objects
  , FMX.Graphics
  , FMX.Types
  , FMX.Effects
  , FMX.Ani
  , FMX.Layouts
  , FMX.ImgList
  , FMX.ListBox
  , Types
  , UITypes
  , SysUtils
  ;

type
  TSliderMenuItem = class(TInterfacedObject, ISliderMenuItem)
  strict private
    FId: Byte;
    FText: string;
    FSubText: string;
    FImageIndex: Integer;
    FAction: TProc<Byte>;
  public
    constructor Create(const Id: Byte; const Text, SubText: string; const Action: TProc<Byte>;
      const ImageIndex: Integer = -1);
    class function New(const Id: Byte; const Text, SubText: string; const Action: TProc<Byte>;
      const ImageIndex: Integer = -1): ISliderMenuItem;
    function Id: Byte;
    function Text: string;
    function SubText: string;
    function ImageIndex: Integer;
    function Action: TProc<Byte>;
  end;

  TSliderMenu = class(TInterfacedObject, ISliderMenu, IFreeNotification)
  strict private
    FRect: TRectangle;
    FMenu: TListBox;
    FShadow: TShadowEffect;
    FAnimation: TFloatAnimation;
    FVisible: Boolean;
    FHiddenX: Single;
    procedure SetupShow;
    procedure SetupHide;
    procedure Click(Sender: TObject);
    procedure Tap(Sender: TObject; const Point: TPointF);
    procedure PrepareShadow;
    procedure PrepareAnimation;
    procedure PrepareListBox(const ImageList: TImageList);
    procedure PrepareRectangle(const aParent: TFmxObject; const ColorStart, ColorEnd: TAlphaColor);
    procedure SetVisible(const Value: Boolean);
    property Visible: Boolean read FVisible write SetVisible;
  public
    constructor Create(const aParent: TFMXObject; const aWidth: Single; const ColorStart, ColorEnd: TAlphaColor;
      const ImageList: TImageList = nil);
    class function New(const aParent: TFMXObject; const aWidth: Single; const ColorStart, ColorEnd: TAlphaColor;
      const ImageList: TImageList = nil): ISliderMenu;
    destructor Destroy; override;
    function Show: ISliderMenu;
    function Hide: ISliderMenu;
    function Toogle: ISliderMenu;
    function Add(const Item: ISliderMenuItem = nil): ISliderMenu;
    function Resize(const aWidth: Single): ISliderMenu;
    function IsVisible: Boolean;
    procedure FreeNotification(AObject: TObject);
  end;

implementation

type
  TListBoxSliderItem = class(TListBoxItem)
  private
    FId: Byte;
    FAction: TProc<Byte>;
  public
    property Id: Byte read FId write FId;
    property Action: TProc<Byte> read FAction write FAction;
  end;

{ TSliderMenu }

function TSliderMenu.Add(const Item: ISliderMenuItem = nil): ISliderMenu;
var
  ListBoxItem: TListBoxSliderItem;
begin
  Result      := Self;
  ListBoxItem := TListBoxSliderItem.Create(FMenu);
  with ListBoxItem do
    begin
      Parent                  := FMenu;
      Align                   := TAlignLayout.Top;
      TextSettings.Font.Size  := 18;
      TextSettings.Font.Style := [TFontStyle.fsBold];
      StyledSettings          := [TStyledSetting.Family, TStyledSetting.FontColor];
      Selectable              := False;
    end;

  if Assigned(Item)
    then begin
      ListBoxItem.Id            := Item.Id;
      ListBoxItem.ItemData.Text := Item.Text;
      ListBoxItem.Hint          := Item.SubText;
      ListBoxItem.ShowHint      := True;
      ListBoxItem.ImageIndex    := Item.ImageIndex;
      ListBoxItem.Action        := Item.Action;
      with TListBoxItem(ListBoxItem) do
        begin
          OnClick := Click;
          OnTap   := Tap;
        end;
    end
    else
      ListBoxItem.ItemData.Text := StringOfChar('─', 5);
end;

procedure TSliderMenu.Click(Sender: TObject);
var
  SliderItem: TListBoxSliderItem;
begin
  Hide;
  if Sender is TListBoxSliderItem
    then SliderItem := Sender as TListBoxSliderItem
    else SliderItem := nil;
  if Assigned(SliderItem.Action)
    then SliderItem.Action(SliderItem.Id);
end;

constructor TSliderMenu.Create(const aParent: TFMXObject; const aWidth: Single; const ColorStart, ColorEnd: TAlphaColor;
  const ImageList: TImageList = nil);
begin
  aParent.AddFreeNotify(Self);
  PrepareRectangle(aParent, ColorStart, ColorEnd);
  PrepareShadow;
  PrepareAnimation;
  PrepareListBox(ImageList);
  Resize(aWidth);
end;

destructor TSliderMenu.Destroy;
begin
  FMenu.Free;
  FShadow.Free;
  FAnimation.Free;
  FRect.Free;
  inherited;
end;

procedure TSliderMenu.FreeNotification(AObject: TObject);
begin
  FRect.Parent := nil;
end;

procedure TSliderMenu.PrepareRectangle(const aParent: TFmxObject; const ColorStart, ColorEnd: TAlphaColor);
begin
  FRect                       := TRectangle.Create(nil);
  FRect.Parent                := aParent;
  FRect.Align                 := TAlignLayout.MostLeft;
  FRect.Stroke.Kind           := TBrushKind.None;
  FRect.Fill.Kind             := TBrushKind.Gradient;
  with FRect.Fill.Gradient do
    begin
      Points.Points[0].Color  := ColorStart;
      Points.Points[0].Offset := 0;
      Points.Points[1].Color  := ColorEnd;
      Points.Points[1].Offset := 1;
      StartPosition.X         := 0;
      StopPosition.X          := 1;
      StartPosition.Y         := 0.5;
      StopPosition.Y          := 0.5;
    end;
end;

procedure TSliderMenu.PrepareListBox(const ImageList: TImageList);
begin
  FMenu             := TListBox.Create(nil);
  FMenu.Parent      := FRect;
  FMenu.Align       := TAlignLayout.Client;
  FMenu.ItemHeight  := 50;
  FMenu.StyleLookup := 'transparentlistboxstyle';
  FMenu.Images      := ImageList;
end;

procedure TSliderMenu.PrepareAnimation;
begin
  FAnimation              := TFloatAnimation.Create(nil);
  FAnimation.Parent       := FRect;
  FAnimation.PropertyName := 'Position.X';
  FAnimation.Duration     := 0.2;
end;

procedure TSliderMenu.PrepareShadow;
begin
  FShadow         := TShadowEffect.Create(nil);
  FShadow.Parent  := FRect;
end;

function TSliderMenu.IsVisible: Boolean;
begin
  Result := FVisible;
end;

function TSliderMenu.Hide: ISliderMenu;
begin
  Result := Self;
  SetupHide;
  FAnimation.Start;
end;

class function TSliderMenu.New(const aParent: TFMXObject; const aWidth: Single; const ColorStart,
  ColorEnd: TAlphaColor; const ImageList: TImageList = nil): ISliderMenu;
begin
  Result := Create(aParent, aWidth, ColorStart, ColorEnd, ImageList);
end;

function TSliderMenu.Resize(const aWidth: Single): ISliderMenu;
begin
  Result            := Self;
  Visible           := False;
  FHiddenX          := -aWidth - 10;
  FRect.Size.Width  := aWidth;
  FRect.Position.X  := FHiddenX;
end;

procedure TSliderMenu.SetupHide;
begin
  Visible               := False;
  FAnimation.StartValue := 0;
  FAnimation.StopValue  := FHiddenX;
end;

procedure TSliderMenu.SetupShow;
begin
  Visible               := True;
  FAnimation.StartValue := FHiddenX;
  FAnimation.StopValue  := 0;
end;

procedure TSliderMenu.SetVisible(const Value: Boolean);
begin
  FVisible      := Value;
  FRect.Visible := Value;
end;

function TSliderMenu.Show: ISliderMenu;
begin
  Result := Self;
  SetupShow;
  FAnimation.Start;
end;

procedure TSliderMenu.Tap(Sender: TObject; const Point: TPointF);
begin
  Click(Sender);
end;

function TSliderMenu.Toogle: ISliderMenu;
begin
  Result := Self;
  if IsVisible
    then Hide
    else Show;
end;

{ TMenuItem }

function TSliderMenuItem.Action: TProc<Byte>;
begin
  Result := FAction;
end;

constructor TSliderMenuItem.Create(const Id: Byte; const Text, SubText: string; const Action: TProc<Byte>;
  const ImageIndex: Integer = -1);
begin
  FId         := Id;
  FText       := Text;
  FSubText    := SubText;
  FImageIndex := ImageIndex;
  FAction     := Action;
end;

function TSliderMenuItem.Id: Byte;
begin
  Result := FId;
end;

function TSliderMenuItem.ImageIndex: Integer;
begin
  Result := FImageIndex;
end;

class function TSliderMenuItem.New(const Id: Byte; const Text, SubText: string; const Action: TProc<Byte>;
  const ImageIndex: Integer): ISliderMenuItem;
begin
  Result := Create(Id, Text, SubText, Action, ImageIndex);
end;

function TSliderMenuItem.SubText: string;
begin
  Result := FSubText;
end;

function TSliderMenuItem.Text: string;
begin
  Result := FText;
end;

end.
