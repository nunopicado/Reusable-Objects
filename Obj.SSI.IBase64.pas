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

unit Obj.SSI.IBase64;

interface

type
    IBase64 = interface ['{B8422767-272C-4BB3-9804-FC9ACBD22FBE}']
      function Encode: IBase64;
      function Decode: IBase64;
      function Reset: IBase64;
      function ToString: String;
    end;

    TBase64 = Class(TInterfacedObject, IBase64)
    private
      FText: String;
      FResult: String;
    public
      constructor Create(Text: String);
      class function New(Text: String): IBase64;
      function Encode: IBase64;
      function Decode: IBase64;
      function Reset: IBase64;
      function ToString: String;
    End;

implementation

uses
    Classes
  , IdCoderMIME
  ;

{ TBase64 }

function TBase64.Encode: IBase64;
var
   Encoder        : TIdEncoderMIME;
   Source, Target : TStringStream;
begin
     Result  := Self;
     Encoder := TIdEncoderMIME.Create(nil);
     try
        Source := TStringStream.Create(FResult);
        Target := TStringStream.Create;
        try
           Encoder.Encode(Source, Target);
           FResult := Target.DataString;
        finally
           Source.Free;
           Target.Free;
        end;
     finally
        Encoder.Free;
     end;
end;

function TBase64.Decode: IBase64;
var
   Decoder : TIdDecoderMIME;
   Target  : TStringStream;
begin
     Result  := Self;
     Decoder := TIdDecoderMIME.Create(nil);
     try
        Target := TStringStream.Create;
        try
           Decoder.DecodeBegin(Target);
           Decoder.Decode(FResult);
           Decoder.DecodeEnd;
           Target.Position := 0;
           FResult := Target.DataString;
        finally
           Target.Free;
        end;
     finally
        Decoder.Free;
     end;
end;

constructor TBase64.Create(Text: String);
begin
     inherited Create;
     FText := Text;
     Reset;
end;

class function TBase64.New(Text: String): IBase64;
begin
     Result := Create(Text);
end;

function TBase64.Reset: IBase64;
begin
     Result  := Self;
     FResult := FText;
end;

function TBase64.ToString: String;
begin
     Result := FResult;
end;

end.
