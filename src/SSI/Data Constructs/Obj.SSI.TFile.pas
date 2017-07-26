unit Obj.SSI.TFile;

interface

uses
    Windows
  , Obj.SSI.IDataStream
  , Obj.SSI.IFile
  , Obj.SSI.IValue
  ;

type
  TFile = Class(TInterfacedObject, IFile)
  private
    FFileName: String;
    FAttributeData: TWin32FileAttributeData;
    function DateConversion(const FileTime: TFileTime): TDateTime;
  public
    constructor Create(const FileName: String);
    class function New(const FileName: String): IFile;
    function Size: Int64;
    function Created: TDateTime;
    function Modified: TDateTime;
    function Accessed: TDateTime;
    function Version(const Full: Boolean = True): IString;
    function AsDataStream: IDataStream;
  End;

implementation

uses
    SysUtils
  , Obj.SSI.TDataStream
  , Obj.SSI.TPrimitive
  , Classes
  ;

{ TFile }

function TFile.Accessed: TDateTime;
begin
  Result := DateConversion(FAttributeData.ftLastAccessTime);
end;

function TFile.AsDataStream: IDataStream;
var
  Buf: TFileStream;
begin
  Buf := TFileStream.Create(FFileName, fmOpenRead);
  try
    Result := TDataStream.New(Buf);
  finally
    Buf.Free;
  end;
end;

constructor TFile.Create(const FileName: String);
begin
  FFileName := FileName;
  if not GetFileAttributesEx(PChar(FFileName), GetFileExInfoStandard, @FAttributeData)
    then RaiseLastOSError;
end;

function TFile.Created: TDateTime;
begin
  Result := DateConversion(FAttributeData.ftCreationTime);
end;

function TFile.DateConversion(const FileTime: TFileTime): TDateTime;
var
  SystemTime: TSystemTime;
begin
  FileTimeToSystemTime(FileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function TFile.Modified: TDateTime;
begin
  Result := DateConversion(FAttributeData.ftLastWriteTime);
end;

class function TFile.New(const FileName: String): IFile;
begin
  Result := Create(FileName);
end;

function TFile.Size: Int64;
begin
  Int64Rec(Result).Lo := FAttributeData.nFileSizeLow;
  Int64Rec(Result).Hi := FAttributeData.nFileSizeHigh;
end;

function TFile.Version(const Full: Boolean = True): IString;
var
  VerInfoSize  : Cardinal;
  VerValueSize : Cardinal;
  Dummy        : Cardinal;
  PVerInfo     : Pointer;
  PVerValue    : PVSFixedFileInfo;
  Res          : string;
begin
  Res         := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FFileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FFileName), 0, VerInfoSize, PVerInfo)
      then if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize)
             then with PVerValue^ do
                    begin
                      Res := Format('%d.%d', [
                        HiWord(dwFileVersionMS),    // Major
                        LoWord(dwFileVersionMS)     // Minor
                      ]);
                      if Full
                        then Res := Format('%s.%d.%d', [
                               Res,
                               HiWord(dwFileVersionLS),   // Release
                               LoWord(dwFileVersionLS)    // Build
                             ]);
                    end;
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
  Result := TString.New(Res);
end;

end.
