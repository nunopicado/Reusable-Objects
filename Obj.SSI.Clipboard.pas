unit Obj.SSI.Clipboard;

interface

uses
    FMX.Platform
  ;

type
    IClipboard = interface
    ['{A047D2F2-A1CD-4611-8503-73C536AB5D47}']
      function Copy(Value: String): IClipboard;
      function Paste: String;
    end;

    TClipboard = Class(TInterfacedObject, IClipboard)
    private
      FClipboard: IFMXClipboardService;
      constructor Create;
    public
      class function New: IClipboard;
      function Copy(Value: String): IClipboard;
      function Paste: String;
    End;

implementation

uses
    SysUtils;

{ TClipboard }

constructor TClipboard.Create;
begin
     if not TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(FClipboard))
        then raise Exception.Create('Clipboard could not be accessed.');
end;

class function TClipboard.New: IClipboard;
begin
     Result := Create;
end;

function TClipboard.Paste: String;
begin
     Result := FClipboard.GetClipboard.ToString;
end;

function TClipboard.Copy(Value: String): IClipboard;
begin
     Result := Self;
     FClipboard.SetClipboard(Value);
end;

end.
