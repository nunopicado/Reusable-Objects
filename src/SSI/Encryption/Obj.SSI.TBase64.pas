(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IBase64                                                  **)
(** Framework     : Indy                                                     **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
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
  , Obj.SSI.IValue
  ;

type
  TBase64 = class(TInterfacedObject, IBase64)
  private
    FText: AnsiString;
  public
    constructor Create(const Text: AnsiString);
    class function New(const Text: IValue<AnsiString>): IBase64; overload;
    class function New(const Text: AnsiString): IBase64; overload;
    function Encode: AnsiString;
    function Decode: AnsiString;
  end;

implementation

uses
    Classes
  , IdCoderMIME
  ;

{ TBase64 }

function TBase64.Encode: AnsiString;
var
  Encoder : TIdEncoderMIME;
  Source  : TStringStream;
  Target  : TStringStream;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Source := TStringStream.Create(FText);
    Target := TStringStream.Create;
    try
      Encoder.Encode(Source, Target);
      Result := Target.DataString;
    finally
      Source.Free;
      Target.Free;
    end;
  finally
    Encoder.Free;
  end;
end;

class function TBase64.New(const Text: AnsiString): IBase64;
begin
  Result := Create(Text);
end;

function TBase64.Decode: AnsiString;
var
  Decoder : TIdDecoderMIME;
  Target  : TStringStream;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    Target := TStringStream.Create;
    try
      Decoder.DecodeBegin(Target);
      Decoder.Decode(FText);
      Decoder.DecodeEnd;
      Target.Position := 0;
      Result := Target.DataString;
    finally
      Target.Free;
    end;
  finally
    Decoder.Free;
  end;
end;

constructor TBase64.Create(const Text: AnsiString);
begin
  inherited Create;
  FText := Text;
end;

class function TBase64.New(const Text: IValue<AnsiString>): IBase64;
begin
  Result := New(Text.Value);
end;

end.
