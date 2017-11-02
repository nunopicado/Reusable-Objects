unit RO.TZipString;

interface

uses
    RO.IValue
  , RO.TString
  ;

type
  TZipString = class(TDecorableIString, IString)
  public
    function Value: string; override;
  end;

  TUnZipString = class(TDecorableIString, IString)
  public
    function Value: string; override;
  end;

implementation

uses
    Classes
  , ZLib
  ;

{ TZipString }

function TZipString.Value: string;
var
  strInput,
  strOutput: TStringStream;
  Zipper: TZCompressionStream;
begin
  Result    := '';
  strInput  := TStringStream.Create(FOrigin.Value);
  strOutput := TStringStream.Create;
  try
    Zipper := TZCompressionStream.Create(TCompressionLevel.clMax, strOutput);
    try
      Zipper.CopyFrom(strInput, strInput.Size);
    finally
      Zipper.Free;
    end;
    Result := strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

{ TUnZipString }

function TUnZipString.Value: string;
var
  strInput,
  strOutput : TStringStream;
  Unzipper  : TZDecompressionStream;
begin
  Result     := '';
  strInput   := TStringStream.Create(FOrigin.Value);
  strOutput  := TStringStream.Create;
  try
    Unzipper := TZDecompressionStream.Create(strInput);
    try
      strOutput.CopyFrom(Unzipper, Unzipper.Size);
    finally
      Unzipper.Free;
    end;
    Result := strOutput.DataString;
  finally
    strInput.Free;
    strOutput.Free;
  end;
end;

end.
