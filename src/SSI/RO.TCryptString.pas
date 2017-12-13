(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICryptString                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TCryptString                                             **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Jedi WinAPI, WinCrypt                                    **)
(******************************************************************************)
(** Description   : Encrypts and decrypts a string                           **)
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

unit RO.TCryptString;

interface

uses
    RO.IValue
  , RO.ICryptString
  ;

type
  TCryptString = class(TInterfacedObject, ICryptString)
  private const
    BufferSize = 1024 * 1024;
    DefaultPassword = '98C9E3C7';
  private var
    FText: AnsiString;
    FPassword: AnsiString;
  public
    constructor Create(const Text, Password: AnsiString); overload;
    constructor Create(const Text: AnsiString); overload;
    class function New(const Text, Password: AnsiString): ICryptString; overload;
    class function New(const Text: AnsiString): ICryptString; overload;
    class function New(const Text, Password: IAnsiString): ICryptString; overload;
    class function New(const Text: IAnsiString): ICryptString; overload;
    function Crypt: AnsiString;
    function Decrypt: AnsiString;
  end;

implementation

uses
    SysUtils
  , Classes
  , JwaWinCrypt
  , JwaWinType
  , RO.TBase64
  , RO.TValue
  ;

type
  ICryptKey = interface
  ['{A1425CC8-66B2-4367-BFC9-CC2A3A549E57}']
    function Key: HCryptKey;
  End;

  TCryptKey = class(TInterfacedObject, ICryptKey)
  private
    FProv : HCryptProv;
    FHash : HCryptHash;
    FKey  : HCryptKey;
  public
    constructor Create(const Password: AnsiString); overload;
    destructor Destroy; override;
    class function New(const Password: AnsiString): ICryptKey;
    function Key: HCryptKey;
  end;

{ TCryptString }

constructor TCryptString.Create(const Text, Password: AnsiString);
begin
  FText     := Text;
  FPassword := Password;
end;

constructor TCryptString.Create(const Text: AnsiString);
begin
  Create(Text, DefaultPassword);
end;

function TCryptString.Crypt: AnsiString;
var
  Source    : TStringStream;
  Target    : TStringStream;
  Buffer    : LPBYTE;
  BytesIn   : DWORD;
  Last      : Boolean;
  FCryptKey : ICryptKey;
begin
  FCryptKey       := TCryptKey.New(FPassword);
  Source          := TStringStream.Create(FText);
  Source.Position := 0;
  Target          := TStringStream.Create;
  try
    GetMem(Buffer, BufferSize);
    try
      repeat
        BytesIn := Source.Read(Buffer^, BufferSize);
        Last    := (Source.Position >= Source.Size);
        if not CryptEncrypt(FCryptKey.Key, 0, Last, 0, Buffer, BytesIn, BytesIn)
          then RaiseLastOSError;
        Target.Write(Buffer^, BytesIn);
      until Last;
      Result := TBase64.New(
        TValue<AnsiString>.New(
          AnsiString(Target.DataString)
        )
      ).Value;
    finally
      FreeMem(Buffer, BufferSize);
    end;
  finally
    Source.Free;
    Target.Free;
  end;
end;

function TCryptString.Decrypt: AnsiString;
var
  Source    : TStringStream;
  Target    : TStringStream;
  Buffer    : LPBYTE;
  BytesIn   : DWORD;
  Last      : Boolean;
  FCryptKey : ICryptKey;
begin
  FCryptKey       := TCryptKey.New(FPassword);
  Source          := TStringStream.Create(
    TUnBase64.New(
      TValue<AnsiString>.New(
        FText
      )
    ).Value
  );
  Source.Position := 0;
  Target          := TStringStream.Create;
  try
    GetMem(Buffer, BufferSize);
    try
      repeat
        BytesIn := Source.Read(Buffer^, BufferSize);
        Last    := (Source.Position >= Source.Size);
        if not CryptDecrypt(FCryptKey.Key, 0, Last, 0, Buffer, BytesIn)
          then RaiseLastOSError;
        Target.Write(Buffer^, BytesIn);
      until Last;
      Result := AnsiString(Target.DataString);
    finally
      FreeMem(Buffer, BufferSize);
    end;
  finally
    Source.Free;
    Target.Free;
  end;
end;

class function TCryptString.New(const Text: AnsiString): ICryptString;
begin
  Result := Create(Text);
end;

class function TCryptString.New(const Text, Password: AnsiString): ICryptString;
begin
  Result := Create(Text, Password);
end;

class function TCryptString.New(const Text,
  Password: IAnsiString): ICryptString;
begin
  Result := New(Text.Value, Password.Value);
end;

class function TCryptString.New(const Text: IAnsiString): ICryptString;
begin
  Result := New(Text.Value);
end;

{ TCryptKey }

constructor TCryptKey.Create(const Password: AnsiString);
begin
  inherited Create;
  CryptAcquireContext(FProv, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT);
  if not CryptCreateHash(FProv, CALG_SHA1, 0, 0, FHash)
    then RaiseLastOSError;
  try
    if not CryptHashData(FHash, @Password[1], Length(Password), 0)
      then RaiseLastOSError;
    if not CryptDeriveKey(FProv,  CALG_RC4, FHash, 0, FKey)
      then RaiseLastOSError;
  finally
    CryptDestroyHash(FHash);
  end;
end;

destructor TCryptKey.Destroy;
begin
  CryptReleaseContext(FProv, 0);
  inherited;
end;

function TCryptKey.Key: HCryptKey;
begin
  Result := FKey;
end;

class function TCryptKey.New(const Password: AnsiString): ICryptKey;
begin
  Result := Create(Password);
end;

end.
