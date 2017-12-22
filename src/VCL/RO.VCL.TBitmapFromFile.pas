(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IBitmap                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TBitmapFromFile                                          **)
(******************************************************************************)
(** Decorators    : TResize - Resizes an IBitmap to a given width and height **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : VCL                                                      **)
(******************************************************************************)
(** Description   : An IBitmap object loaded from an image file              **)
(**                 Supports BMP, TIF, JPG, PNG                              **)
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

unit RO.VCL.TBitmapFromFile;

interface

uses
    RO.VCL.IBitmap
  , Vcl.Graphics
  , RO.IValue
  ;

type
  TBitmapFromFile = class(TInterfacedObject, IBitmap)
  private
    FBitmap: IValue<TBitmap>;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    class function New(const FileName: string): IBitmap;
    function AsBitmap: TBitmap;
  end;

  TResize = class(TInterfacedObject, IBitmap)
  private
    FBitmap: IValue<TBitmap>;
  public
    constructor Create(const Origin: IBitmap; const Width, Height: Integer);
    destructor Destroy; override;
    class function New(const Origin: IBitmap; const Width, Height: Integer): IBitmap;
    function AsBitmap: TBitmap;
  end;

implementation

uses
    RO.TValue
  , Windows
  , Vcl.ExtCtrls
  , Jpeg
  , PngImage
  ;

{ TBitmapFromFile }

function TBitmapFromFile.AsBitmap: Vcl.Graphics.TBitmap;
begin
  Result := FBitmap.Value;
end;

constructor TBitmapFromFile.Create(const FileName: string);
begin
  FBitmap := TValue<Vcl.Graphics.TBitmap>.New(
    function : Vcl.Graphics.TBitmap
    var
      Img : TImage;
    begin
      Img := TImage.Create(nil);
      try
        Img.Picture.LoadFromFile(FileName);
        Result := Vcl.Graphics.TBitmap.Create;
        Result.Assign(Img.Picture.Graphic);
      finally
        Img.Free;
      end;
    end
  );
end;

destructor TBitmapFromFile.Destroy;
begin
  if Assigned(FBitmap.Value)
    then FBitmap.Value.Free;
  inherited;
end;

class function TBitmapFromFile.New(const FileName: string): IBitmap;
begin
  Result := Create(FileName);
end;

{ TResizeBitmap }

function TResize.AsBitmap: Vcl.Graphics.TBitmap;
begin
  Result := FBitmap.Value;
end;

constructor TResize.Create(const Origin: IBitmap; const Width, Height: Integer);
begin
  FBitmap := TValue<Vcl.Graphics.TBitmap>.New(
    function : Vcl.Graphics.TBitmap
    begin
      Result := Vcl.Graphics.TBitmap.Create;
      Result.SetSize(Width, Height);
      SetStretchBltMode(Result.Canvas.Handle, HALFTONE);
      StretchBlt(
        Result.Canvas.Handle, 0, 0, Result.Width, Result.Height,
        Origin.AsBitmap.Canvas.Handle, 0, 0, Origin.AsBitmap.Width, Origin.AsBitmap.Height,
        SRCCOPY
      );
    end
  );
end;

destructor TResize.Destroy;
begin
  if Assigned(FBitmap.Value)
    then FBitMap.Value.Free;
  inherited;
end;

class function TResize.New(const Origin: IBitmap; const Width, Height: Integer): IBitmap;
begin
  Result := Create(Origin, Width, Height);
end;

end.
