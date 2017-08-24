(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TCertificate                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado, WinCrypt items merged from ACBr_WinCrypt.pas**)
(******************************************************************************)
(** Interfaces    : ICertificate                                             **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Handles PFX certificate files                            **)
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

unit Obj.SSI.TCertificate;

interface

uses
    Obj.SSI.ICertificate
  , Obj.SSI.IValue
  , Windows
  , Classes
  ;

type
// WinCrypt Headers
{$REGION WinCryptHeaders}
  {$EXTERNALSYM _CRYPTOAPI_BLOB}
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PBYTE;
  end;

  {$EXTERNALSYM CRYPT_OBJID_BLOB}
  CRYPT_OBJID_BLOB = _CRYPTOAPI_BLOB;

  {$EXTERNALSYM _CRYPT_ALGORITHM_IDENTIFIER}
  _CRYPT_ALGORITHM_IDENTIFIER = record
    pszObjId: LPSTR;
    Parameters: CRYPT_OBJID_BLOB;
  end;

  {$EXTERNALSYM CRYPT_ALGORITHM_IDENTIFIER}
  CRYPT_ALGORITHM_IDENTIFIER = _CRYPT_ALGORITHM_IDENTIFIER;

  {$EXTERNALSYM CRYPT_INTEGER_BLOB}
  CRYPT_INTEGER_BLOB = _CRYPTOAPI_BLOB;

  {$EXTERNALSYM CERT_NAME_BLOB}
  CERT_NAME_BLOB = _CRYPTOAPI_BLOB;

  {$EXTERNALSYM _CRYPT_BIT_BLOB}
  _CRYPT_BIT_BLOB = record
    cbData: DWORD;
    pbData: PBYTE;
    cUnusedBits: DWORD;
  end;

  {$EXTERNALSYM CRYPT_BIT_BLOB}
  CRYPT_BIT_BLOB = _CRYPT_BIT_BLOB;

  {$EXTERNALSYM _CERT_PUBLIC_KEY_INFO}
  _CERT_PUBLIC_KEY_INFO = record
    Algorithm: CRYPT_ALGORITHM_IDENTIFIER;
    PublicKey: CRYPT_BIT_BLOB;
  end;

  {$EXTERNALSYM CERT_PUBLIC_KEY_INFO}
  CERT_PUBLIC_KEY_INFO = _CERT_PUBLIC_KEY_INFO;

  PCertExtension = ^TCertExtension;
  {$EXTERNALSYM _CERT_EXTENSION}
  _CERT_EXTENSION = record
    pszObjId: LPSTR;
    fCritical: BOOL;
    Value: CRYPT_OBJID_BLOB;
  end;
  TCertExtension = _CERT_EXTENSION;

  {$EXTERNALSYM _CERT_INFO}
  _CERT_INFO = record
    dwVersion: DWORD;
    SerialNumber: CRYPT_INTEGER_BLOB;
    SignatureAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    Issuer: CERT_NAME_BLOB;
    NotBefore: FILETIME;
    NotAfter: FILETIME;
    Subject: CERT_NAME_BLOB;
    SubjectPublicKeyInfo: CERT_PUBLIC_KEY_INFO;
    IssuerUniqueId: CRYPT_BIT_BLOB;
    SubjectUniqueId: CRYPT_BIT_BLOB;
    cExtension: DWORD;
    rgExtension: PCertExtension;
  end;

  {$EXTERNALSYM PCERT_INFO}
  PCERT_INFO = ^_CERT_INFO;

  {$EXTERNALSYM HCERTSTORE}
  HCERTSTORE = Pointer;

  {$EXTERNALSYM _CERT_CONTEXT}
  _CERT_CONTEXT = record
    dwCertEncodingType: DWORD;
    pbCertEncoded: PByte;
    cbCertEncoded: DWORD;
    pCertInfo: PCERT_INFO;
    hCertStore: HCERTSTORE;
  end;

  {$EXTERNALSYM CERT_CONTEXT}
  CERT_CONTEXT = _CERT_CONTEXT;

  {$EXTERNALSYM PCCERT_CONTEXT}
  PCCERT_CONTEXT = ^CERT_CONTEXT;

  {$EXTERNALSYM CRYPT_DATA_BLOB}
  CRYPT_DATA_BLOB = _CRYPTOAPI_BLOB;

  {$EXTERNALSYM HCRYPTPROV_OR_NCRYPT_KEY_HANDLE}
  HCRYPTPROV_OR_NCRYPT_KEY_HANDLE = ULONG_PTR;

  {$EXTERNALSYM HCRYPTPROV}
  HCRYPTPROV = ULONG_PTR;
{$ENDREGION}

  TCertificate = class(TInterfacedObject, ICertificate)
  private
    FPFXFile: string;
    FPFXPass: string;
    FPFXData: IValue<AnsiString>;
    FContext: IValue<Pointer>;
    function GetPFXData: AnsiString;
    function GetPCCert_Context: PCCert_Context;
  public
    constructor Create(const PFXFile, PFXPass: string);
    class function New(const PFXFile, PFXPass: string): ICertificate;
    function AsPCCert_Context: Pointer;
    function ContextSize: Cardinal;
    function IsValid: Boolean;
    function SerialNumber: string;
    function NotAfter: TDateTime;
  end;

// WinCrypt Functions
{$REGION WinCryptFunctions}

{$EXTERNALSYM PFXIsPFXBlob}
function PFXIsPFXBlob(var pPFX: CRYPT_DATA_BLOB): BOOL; stdcall;

{$EXTERNALSYM PFXVerifyPassword}
function PFXVerifyPassword(var pPFX: CRYPT_DATA_BLOB; szPassword: LPCWSTR;
  dwFlags: DWORD): BOOL; stdcall;

{$EXTERNALSYM PFXImportCertStore}
function PFXImportCertStore(var pPFX: CRYPT_DATA_BLOB;
  szPassword: LPCWSTR; dwFlags: DWORD): HCERTSTORE; stdcall;

{$EXTERNALSYM CertEnumCertificatesInStore}
function CertEnumCertificatesInStore(hCertStore: HCERTSTORE;
  var pPrevCertContext: CERT_CONTEXT): PCCERT_CONTEXT; stdcall;

{$EXTERNALSYM CryptAcquireCertificatePrivateKey}
function CryptAcquireCertificatePrivateKey(pCert: PCCERT_CONTEXT;
  dwFlags: DWORD; pvReserved: Pointer;
  var phCryptProvOrNCryptKey: HCRYPTPROV_OR_NCRYPT_KEY_HANDLE;
  var pdwKeySpec: DWORD; var pfCallerFreeProvOrNCryptKey: BOOL): BOOL; stdcall;

{$EXTERNALSYM CryptReleaseContext}
function CryptReleaseContext(hProv: HCRYPTPROV; dwFlags: DWORD): BOOL; stdcall;
{$ENDREGION}

implementation

uses
    Obj.SSI.TValue
  , SysUtils
  ;

// WinCrypt Consts
{$REGION WinCryptConsts}
const
  Crypt32 = 'crypt32.dll';

  {$EXTERNALSYM CRYPT_EXPORTABLE}
  CRYPT_EXPORTABLE        = $00000001;

  PKCS12_INCLUDE_EXTENDED_PROPERTIES = $10;

  {$EXTERNALSYM CRYPT_ACQUIRE_ALLOW_NCRYPT_KEY_FLAG}
  CRYPT_ACQUIRE_ALLOW_NCRYPT_KEY_FLAG   = $00010000;
{$ENDREGION}

// WinCrypt Functions Importation
{$REGION WinCryptFunctionsImportation}
function PFXIsPFXBlob; external Crypt32 name 'PFXIsPFXBlob';
function PFXVerifyPassword; external Crypt32 name 'PFXVerifyPassword';
function PFXImportCertStore; external Crypt32 name 'PFXImportCertStore';
function CertEnumCertificatesInStore; external Crypt32 name 'CertEnumCertificatesInStore';
function CryptAcquireCertificatePrivateKey; external Crypt32 name 'CryptAcquireCertificatePrivateKey';
function CryptReleaseContext; external Advapi32 name 'CryptReleaseContext';
{$ENDREGION}

{ TCertificate }

function TCertificate.SerialNumber: String;
var
  i           : Integer;
  ByteArr     : array of Byte;
  CertContext : PCCert_Context;
begin
  Result      := '';
  CertContext := AsPCCert_Context;
  if Assigned(CertContext)
    then begin
      SetLength(ByteArr, CertContext^.pCertInfo^.SerialNumber.cbData);
      Move(
        CertContext^.pCertInfo^.SerialNumber.pbData^,
        ByteArr[0],
        CertContext^.pCertInfo^.SerialNumber.cbData
      );
      for i := 0 to Pred(CertContext^.pCertInfo^.SerialNumber.cbData) do
        Result := IntToHex(ByteArr[I], 2) + Result;
      Result := Trim(UpperCase(Result));
    end;
end;

function TCertificate.NotAfter: TDateTime;
var
  LocalFileTime : TFileTime;
  SystemTime    : TSystemTime;
  CertContext   : PCCERT_CONTEXT;
begin
  Result      := 0;
  CertContext := AsPCCert_Context;
  if Assigned(CertContext)
    then begin
      FileTimeToLocalFileTime(TFileTime(CertContext^.pCertInfo^.NotAfter), LocalFileTime);
      FileTimeToSystemTime(LocalFileTime, SystemTime);
      Result := SystemTimeToDateTime(SystemTime);
    end;
end;

function TCertificate.ContextSize: Cardinal;
begin
  Result := Sizeof(PCCert_Context(AsPCCert_Context^)) * 5;
end;

function TCertificate.AsPCCert_Context: Pointer;
begin
  Result := FContext.Value;
end;

constructor TCertificate.Create(const PFXFile, PFXPass: string);
begin
  if not FileExists(PFXFile)
    then raise Exception.Create(
      Format(
        'Certificate file could not be read: %s',
        [ExtractFileName(PFXFile)]
      )
    );
  FPFXFile := PFXFile;
  FPFXPass := PFXPass;
  FPFXData := TValue<AnsiString>.New(GetPFXData);
  FContext := TValue<Pointer>.New(GetPCCert_Context);
end;

function TCertificate.GetPCCert_Context: PCCert_Context;
var
  CertStore          : Pointer;
  PFXBlob            : Crypt_Data_Blob;
  PFXCert            : PCCert_Context;
  WSPass             : LPCWSTR;
  DwKeySpec          : DWord;
  PfCallerFreeProv   : LongBool;
  ProviderOrKeyHandle: HCryptProv_Or_NCrypt_Key_Handle;
begin
  // Certificate file validation
  PFXBlob.CbData := Length(FPFXData.Value);
  PFXBlob.PbData := PByte(FPFXData.Value);
  if not PFXIsPFXBlob(PFXBlob)
    then raise Exception.Create('Invalid certificate data.');

  // Password validation
  WSPass := PWideChar(FPFXPass);
  if not PFXVerifyPassword(PFXBlob, WsPass, 0)
    then raise Exception.Create('Invalid certificate password.');

  // Certificate store validation
  CertStore := PFXImportCertStore(
    PFXBlob,
    WsPass,
    CRYPT_EXPORTABLE or
    { PKCS12_PREFER_CNG_KSP or }
    PKCS12_INCLUDE_EXTENDED_PROPERTIES
  );
  if not Assigned(CertStore)
    then raise Exception.Create('Could not access certificate store.');

  // Find certificate in certificate chain
  Result  := nil;
  PFXCert := nil;
  PFXCert := CertEnumCertificatesInStore(
    CertStore,
    PFXCert^
  );
  while (PFXCert <> nil) and (Result = nil) do
    begin
      // Check if certificate has a private key
      PfCallerFreeProv    := False;
      ProviderOrKeyHandle := 0;
      DwKeySpec           := 0;
      if CryptAcquireCertificatePrivateKey(
           PFXCert,
           Crypt_Acquire_Allow_NCrypt_Key_Flag,
           nil,
           ProviderOrKeyHandle,
           DwKeySpec,
           PfCallerFreeProv
         )
        then Result := PFXCert;

      if PfCallerFreeProv and (ProviderOrKeyHandle <> 0)
        then CryptReleaseContext(
          ProviderOrKeyHandle,
          0
        );

      if Result = nil
        then PFXCert := CertEnumCertificatesInStore(
          CertStore,
          PFXCert^
        );
    end;
  if not Assigned(Result)
    then raise Exception.Create('Could not find a client certificate with a private key.');
end;

function TCertificate.GetPFXData: AnsiString;
var
  x         : Integer;
  PFXStream : TFileStream;
begin
  PFXStream := TFileStream.Create(FPFXFile, fmOpenRead or fmShareDenyNone);
  try
    Setlength(Result, PFXStream.Size);
    x := PFXStream.Read(PAnsiChar(Result)^, PFXStream.Size);
    SetLength(Result, x);
  finally
    PFXStream.Free;
  end;
end;

function TCertificate.IsValid: Boolean;
begin
  Result := (Date <= NotAfter);
end;

class function TCertificate.New(const PFXFile, PFXPass: string): ICertificate;
begin
  Result := Create(PFXFile, PFXPass);
end;

end.
