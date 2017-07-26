(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TLightBox, descends from TRectangle                      **)
(******************************************************************************)
(** Dependencies  : FMX                                                      **)
(******************************************************************************)
(** Description   : An FMX TRectangle descendant that creates a LightBox     **)
(**                 effect                                                   **)
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
