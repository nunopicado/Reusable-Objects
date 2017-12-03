(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TBase64                                                  **)
(**                 TUnBase64                                                **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
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

unit RO.TBase64;

interface

uses
    RO.IValue
  , RO.TValue
  ;

type
  TBase64 = class(TInterfacedObject, IValue<AnsiString>)
  private
    FOrigin: IValue<AnsiString>;
  public
    constructor Create(const Origin: IValue<AnsiString>);
    class function New(const Origin: IValue<AnsiString>): IValue<AnsiString>;
    function Value: AnsiString;
    function Refresh: IValue<AnsiString>;
  end;

  TUnBase64 = class(TInterfacedObject, IValue<AnsiString>)
  private
    FOrigin: IValue<AnsiString>;
  public
    constructor Create(const Origin: IValue<AnsiString>);
    class function New(const Origin: IValue<AnsiString>): IValue<AnsiString>;
    function Value: AnsiString;
    function Refresh: IValue<AnsiString>;
  end;

implementation

uses
    Classes
  , IdCoderMIME
  ;

{ TBase64 }

function TBase64.Value: AnsiString;
var
  Encoder : TIdEncoderMIME;
  Source  : TStringStream;
  Target  : TStringStream;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Source := TStringStream.Create(FOrigin.Value);
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

class function TBase64.New(const Origin: IValue<AnsiString>): IValue<AnsiString>;
begin
  Result := Create(Origin);
end;

function TBase64.Refresh: IValue<AnsiString>;
begin
  Result := Self;
  FOrigin.Refresh;
end;

constructor TBase64.Create(const Origin: IValue<AnsiString>);
begin
  inherited Create;
  FOrigin := Origin;
end;

{ TUnBase64 }

class function TUnBase64.New(const Origin: IValue<AnsiString>): IValue<AnsiString>;
begin
  Result := Create(Origin);
end;

function TUnBase64.Refresh: IValue<AnsiString>;
begin
  Result := Self;
  FOrigin.Refresh;
end;

function TUnBase64.Value: AnsiString;
var
  Decoder : TIdDecoderMIME;
  Target  : TStringStream;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    Target := TStringStream.Create;
    try
      Decoder.DecodeBegin(Target);
      Decoder.Decode(FOrigin.Value);
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

constructor TUnBase64.Create(const Origin: IValue<AnsiString>);
begin
  inherited Create;
  FOrigin := Origin;
end;

end.
