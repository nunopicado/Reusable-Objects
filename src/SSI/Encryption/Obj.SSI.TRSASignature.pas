(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TRSASignature                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : TRSASignature                                            **)
(******************************************************************************)
(** Dependencies  : OpenSSL                                                  **)
(******************************************************************************)
(** Description   : Signs a string with RSA protocol                         **)
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

unit Obj.SSI.TRSASignature;

interface

uses
    Obj.SSI.IRSASignature
  , Obj.SSI.IValue
  ;

type
  TRSASignature = class(TInterfacedObject, IRSASignature)
  private
    FStrIn: string;
    FPubKey: string;
    FPubKeySource: TPubKeySource;
    FStrOut: IString;
    function GenerateSignature: string;
  public
    constructor Create(const StrIn, PubKey: string; PubKeySource: TPubKeySource);
    class function New(const StrIn, PubKey: string; PubKeySource: TPubKeySource = pksString): IRSASignature;
    function AsString: string;
  end;

implementation

uses
    Obj.SSI.TValue
  , SysUtils
  , AnsiStrings
  , LibEAY32
  ;

{ TRSASignature }

function TRSASignature.AsString: string;
begin
  Result := FStrOut.Value;
end;

constructor TRSASignature.Create(const StrIn, PubKey: string; PubKeySource: TPubKeySource);
begin
  FStrIn        := StrIn;
  FPubKey       := PubKey;
  FPubKeySource := PubKeySource;
  FStrOut       := TString.NewDelayed(GenerateSignature);
end;

function TRSASignature.GenerateSignature: string;
  function ReadPublicKeyFromFile(const AFileName: AnsiString): pEVP_PKEY;
  var
    KeyFile : pBIO;
    Key     : pEVP_PKEY;
  begin
    Key     := nil;
    KeyFile := BIO_New(BIO_s_File());
    BIO_Read_Filename(KeyFile, PAnsiChar(AFilename));
    Result  := PEM_read_bio_PUBKEY(KeyFile, Key, nil, nil);
    BIO_Free(KeyFile);
  end;

  function ReadPublicKeyFromString(const PublicKey: AnsiString): pEVP_PKEY;
  var
    KeyStr : pBIO;
    Key    : pEVP_PKEY;
  begin
    Key    := nil;
    KeyStr := BIO_New_Mem_Buf(PAnsiChar(PublicKey), Length(PublicKey));
    try
      Result := PEM_Read_Bio_PubKey(KeyStr, Key, nil, nil);
    finally
      BIO_Free(KeyStr);
    end;
  end;

const
  BIO_FLAGS_BASE64_NO_NL = $100;
var
  Key: pEVP_PKEY;
  InBuf, OutBuf, OutBuf64: array[0..2047] of AnsiChar;
  B64, BMem: pBIO;
  RSA: pRSA;
  ClearText: pBIO;
  KeySize: Integer;
  RSAin, RSAout: Pointer;
  RSAinLen: Integer;
begin
  Result := '';

  LibEAY32.OpenSSL_Add_All_Algorithms;
  LibEAY32.OpenSSL_Add_All_Ciphers;
  LibEAY32.OpenSSL_Add_All_Digests;
  Err_Load_Crypto_Strings;

  case FPubKeySource of
    pksFile   : Key := ReadPublicKeyFromFile(FPubKey);
    pksString : Key := ReadPublicKeyFromString(FPubKey);
  end;

  if not Assigned(Key) then
    raise Exception.Create('ChavePublicAT não pôde ser lida.');

  RSA := EVP_PKey_Get1_RSA(Key);
  EVP_PKey_Free(Key);

  FillChar(InBuf[0], 2048, #0);
  FillChar(OutBuf[0], 2048, #0);
  FillChar(OutBuf64[0], 2048, #0);

  AnsiStrings.StrPCopy(InBuf, AnsiString(FStrIn));

  ClearText := BIO_New_Mem_Buf(@InBuf, Length(FStrIn));
  BIO_Write(ClearText, @InBuf, Length(FStrIn));

  KeySize := RSA_Size(RSA);

  // Should be free if exception is raised
  RSAin  := OPENSSL_Malloc(KeySize * 2);
  RSAout := OPENSSL_Malloc(KeySize);

  // Read the input data
  RSAinLen := BIO_Read(ClearText, RSAin, KeySize * 2);
  RSA_Public_Encrypt(RSAinLen, @InBuf, @OutBuf, RSA, RSA_PKCS1_Padding);

  RSA_Free(RSA);
  BIO_Free(ClearText);
  if Assigned(RSAin)
    then OpenSSL_Free(RSAin);
  if Assigned(RSAout)
    then OpenSSL_Free(RSAout);

  // Converter para base64
  B64  := BIO_New(BIO_f_Base64());
  BMem := BIO_New(BIO_s_Mem());
  B64  := BIO_Push(B64, BMem);
  BIO_Write(B64, @OutBuf, KeySize);
  BIO_Flush(B64);
  BIO_Read(BMem, @OutBuf64, 2048);
  BIO_Free_All(B64);

  Result := string(AnsiStrings.StrPas(OutBuf64));
end;

class function TRSASignature.New(const StrIn, PubKey: string; PubKeySource: TPubKeySource = pksString): IRSASignature;
begin
  Result := Create(StrIn, PubKey, PubKeySource);
end;

end.
