(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IIcon                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TIconFromBitmap                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : VCL                                                      **)
(******************************************************************************)
(** Description   : Converts a Bitmap into an Icon                           **)
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

unit RO.VCL.TIconFromBitmap;

interface

uses
    RO.VCL.IIcon
  , RO.VCL.IBitmap
  , RO.IValue
  , Vcl.Graphics
  ;

type
  TIconFromBitmap = class(TInterfacedObject, IIcon)
  private
    FIcon: IValue<TIcon>;
  public
    constructor Create(const Bitmap: TBitmap);
    destructor Destroy; override;
    class function New(const Bitmap: TBitmap): IIcon; overload;
    class function New(const Bitmap: IBitmap): IIcon; overload;
    function AsIcon: TIcon;
  end;

implementation

uses
    RO.TValue
  , Windows
  ;

{ TIconFromBitmap }

function TIconFromBitmap.AsIcon: TIcon;
begin
  Result := FIcon.Value;
end;

constructor TIconFromBitmap.Create(const Bitmap: Vcl.Graphics.TBitmap);
begin
  FIcon := TValue<TIcon>.New(
    function : TIcon
    var
      BmpMask   : Vcl.Graphics.TBitmap;
      IconInfo  : TIconInfo;
    begin
      BmpMask := Vcl.Graphics.TBitmap.Create;
      try
        BmpMask.Canvas.Brush.Color := clBlack;
        BmpMask.SetSize(Bitmap.Width, Bitmap.Height);
        FillChar(IconInfo, SizeOf(IconInfo), 0);
        IconInfo.fIcon    := True;
        IconInfo.hbmMask  := BmpMask.Handle;
        IconInfo.hbmColor := Bitmap.Handle;
        Result            := TIcon.Create;
        Result.Handle     := CreateIconIndirect(IconInfo);
      finally
        BmpMask.Free;
      end;
    end
  );
end;

destructor TIconFromBitmap.Destroy;
begin
  if Assigned(FIcon.Value)
    then FIcon.Value.Free;
  inherited;
end;

class function TIconFromBitmap.New(const Bitmap: IBitmap): IIcon;
begin
  Result := Create(Bitmap.AsBitmap);
end;

class function TIconFromBitmap.New(const Bitmap: Vcl.Graphics.TBitmap): IIcon;
begin
  Result := Create(Bitmap);
end;

end.
