(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TAES128                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IAES128                                                  **)
(******************************************************************************)
(** Dependencies  : DelphiOnRails                                            **)
(******************************************************************************)
(** Description   : Encrypts a string with AES128 protocol                   **)
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

unit Obj.SSI.TAES128;

interface

uses
    Obj.SSI.IAES128
  , Obj.SSI.IValue
  , LibEay.Ext
  ;

type
  TAES128 = class(TInterfacedObject, IAES128)
  private type
    TKey = array[0..EVP_MAX_KEY_LENGTH - 1] of Byte;
    TIV  = array[0..EVP_MAX_IV_LENGTH - 1] of Byte;
  private var
    FCipherContext: EVP_CIPHER_CTX;
    FSecretKey: string;
    FStrIn: string;
    FOut: IString;
  private
    function AESEncrypt: string;
  public
    constructor Create(const SecretKey, StrIn: string);
    class function New(const SecretKey, StrIn: string): IAES128;
    function AsString: string;
  end;

implementation

uses
    Obj.SSI.TValue
  , Obj.SSI.TBase64
  , SysUtils
  , LibEay32
  ;

{ TAES }

function TAES128.AsString: string;
begin
  Result := FOut.Value;
end;

constructor TAES128.Create(const SecretKey, StrIn: string);
begin
  FSecretKey := SecretKey;
  FStrIn     := StrIn;
  FOut       := TString.New(AESEncrypt);
end;

class function TAES128.New(const SecretKey, StrIn: string): IAES128;
begin
  Result := Create(SecretKey, StrIn);
end;

function TAES128.AESEncrypt: string;
var
  Cipher    : PEVP_CIPHER;
  Key       : TKey;
  SecretKey : RawByteString;
  StrIn     : RawByteString;
  InLen     : Integer;
  StrOut1   : RawByteString;
  StrOut2   : RawByteString;
  OutLen    : Integer;
begin
  Cipher := EVP_get_cipherbyname(PAnsiChar(AnsiString('aes-128-ecb')));
  FillChar(Key, SizeOf(TKey), 0);
  EVP_CipherInit_ex(@FCipherContext, Cipher, nil, PByte(@Key), nil, -1);
  EVP_CipherInit_ex(@FCipherContext, nil, nil, nil, nil, 1);
  SecretKey := RawByteString(FSecretKey);
  if Length(SecretKey) < EVP_CIPHER_CTX_key_length(@FCipherContext)
    then raise Exception.Create('Key length too short');
  EVP_CipherInit_ex(@FCipherContext, nil, nil, Pointer(SecretKey), nil, -1);
  StrIn := RawByteString(FStrIn);
  InLen := Length(StrIn);
  if InLen = 0
    then raise Exception.Create('Data must not be empty');
  OutLen := InLen + EVP_CIPHER_CTX_block_size(@FCipherContext);
  SetLength(StrOut1, OutLen);
  EVP_CipherUpdate(@FCipherContext, Pointer(StrOut1), @OutLen, Pointer(StrIn), InLen);
  Assert(OutLen < Length(StrOut1));
  SetLength(StrOut1, OutLen);
  SetLength(StrOut2, EVP_CIPHER_CTX_block_size(@FCipherContext));
  EVP_CipherFinal_ex(
    @FCipherContext,
    Pointer(StrOut2),
    @OutLen
  );
  SetLength(StrOut2, OutLen);
  Result := string(
    TBase64.New(
      StrOut1 + StrOut2
    ).Encode
  );
  EVP_CIPHER_CTX_free(@FCipherContext);
end;

end.
