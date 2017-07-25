(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IBase64                                                  **)
(** Framework     : Indy                                                     **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IBase64                                                  **)
(** Classes       : TBase64, implements IBase64                              **)
(******************************************************************************)
(** Dependencies  : RTL, Indy                                                **)
(******************************************************************************)
(** Description   : Encodes/Decodes To/From Base64 strings                   **)
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

unit Obj.SSI.TBase64;

interface

uses
    Obj.SSI.IBase64
  , Obj.SSI.IPrimitive
  ;

type
  TBase64 = Class(TInterfacedObject, IBase64)
  private
    FText: IString;
  public
    constructor Create(const Text: IString);
    class function New(const Text: IString): IBase64;
    function Encode: IString;
    function Decode: IString;
  end;

implementation

uses
    Classes
  , IdCoderMIME
  , Obj.SSI.TPrimitive
  ;

{ TBase64 }

function TBase64.Encode: IString;
var
  Encoder : TIdEncoderMIME;
  Source  : TStringStream;
  Target  : TStringStream;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Source := TStringStream.Create(FText.Value);
    Target := TStringStream.Create;
    try
      Encoder.Encode(Source, Target);
      Result := TString.New(Target.DataString);
    finally
      Source.Free;
      Target.Free;
    end;
  finally
    Encoder.Free;
  end;
end;

function TBase64.Decode: IString;
var
  Decoder : TIdDecoderMIME;
  Target  : TStringStream;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    Target := TStringStream.Create;
    try
      Decoder.DecodeBegin(Target);
      Decoder.Decode(FText.Value);
      Decoder.DecodeEnd;
      Target.Position := 0;
      Result := TString.New(Target.DataString);
    finally
      Target.Free;
    end;
  finally
    Decoder.Free;
  end;
end;

constructor TBase64.Create(const Text: IString);
begin
  inherited Create;
  FText := Text;
end;

class function TBase64.New(const Text: IString): IBase64;
begin
  Result := Create(Text);
end;

end.
