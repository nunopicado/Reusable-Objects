unit RO.TBase64File;

interface

uses
    RO.IValue
  ;

type
  TBase64File = class(TInterfacedObject, IString)
  private
    FBase64: IString;
  public
    constructor Create(const FileName: string);
    class function New(const FileName: string): IString;
    function Value: string;
    function Refresh: IString;
  end;

implementation

uses
    RO.TValue
  , Classes
  , SysUtils
  , NetEncoding
  ;

{ TBase64File }

constructor TBase64File.Create(const FileName: string);
begin
  FBase64 := TString.New(
    function : string
    var
      Source: TFileStream;
      Target: TStringStream;
    begin
      Source := TFileStream.Create(FileName, fmOpenRead);
      try
        Target := TStringStream.Create;
        try
          TNetEncoding.Base64.Encode(Source, Target);
          Result := Target.DataString;
        finally
          Target.Free;
        end;
      finally
        Source.Free;
      end;
    end
  );
end;

class function TBase64File.New(const FileName: string): IString;
begin
  Result := Create(FileName);
end;

function TBase64File.Refresh: IString;
begin
  Result := Self;
  FBase64.Refresh;
end;

function TBase64File.Value: string;
begin
  Result := FBase64.Value;
end;

end.
