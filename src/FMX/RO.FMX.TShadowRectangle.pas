(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TShadowRectangle                                         **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : FMX                                                      **)
(******************************************************************************)
(** Description   : An FMX TRectangle descendant that creates a shadow       **)
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

unit RO.FMX.TShadowRectangle;

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
