(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IFile                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TFile, implements IFile                                  **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Opens a file for reading, gets its content and info      **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit RO.TFile;

interface

uses
    Windows
  , RO.IDataStream
  , RO.IFile
  , RO.IValue
  ;

type
  TFile = class(TInterfacedObject, IFile)
  private
    FFileName: string;
    FAttributeData: TWin32FileAttributeData;
    function DateConversion(const FileTime: TFileTime): TDateTime;
  public
    constructor Create(const FileName: string);
    class function New(const FileName: string): IFile; overload;
    class function New(const FileName: IString): IFile; overload;
    function Size: Int64;
    function Created: TDateTime;
    function Modified: TDateTime;
    function Accessed: TDateTime;
    function Version(const Full: Boolean = True): string; overload;
    function Version(const Full: IBoolean): string; overload;
    function AsDataStream: IDataStream;
  end;

implementation

uses
    SysUtils
  , RO.TDataStream
  , RO.TValue
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

constructor TFile.Create(const FileName: string);
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

class function TFile.New(const FileName: IString): IFile;
begin
  Result := New(Filename.Value);
end;

class function TFile.New(const FileName: string): IFile;
begin
  Result := Create(FileName);
end;

function TFile.Size: Int64;
begin
  Int64Rec(Result).Lo := FAttributeData.nFileSizeLow;
  Int64Rec(Result).Hi := FAttributeData.nFileSizeHigh;
end;

function TFile.Version(const Full: IBoolean): string;
begin
  Result := Version(Full.Value);
end;

function TFile.Version(const Full: Boolean = True): string;
var
  VerInfoSize  : Cardinal;
  VerValueSize : Cardinal;
  Dummy        : Cardinal;
  PVerInfo     : Pointer;
  PVerValue    : PVSFixedFileInfo;
begin
  Result      := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FFileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FFileName), 0, VerInfoSize, PVerInfo)
      then if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize)
             then with PVerValue^ do
                    begin
                      Result := Format('%d.%d', [
                        HiWord(dwFileVersionMS),    // Major
                        LoWord(dwFileVersionMS)     // Minor
                      ]);
                      if Full
                        then Result := Format('%s.%d.%d', [
                               Result,
                               HiWord(dwFileVersionLS),   // Release
                               LoWord(dwFileVersionLS)    // Build
                             ]);
                    end;
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

end.
