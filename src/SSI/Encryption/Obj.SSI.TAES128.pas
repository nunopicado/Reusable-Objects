(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : TAES128, decorates IString                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IString (IValue<string>)                                 **)
(******************************************************************************)
(** Dependencies  : OpenSSL                                                  **)
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
    Obj.SSI.IValue
  , Obj.SSI.TString
  , LibEay.Ext
  ;

type
  TAES128 = class(TDecorableIString, IString)
  private type
    TKey = array[0..EVP_MAX_KEY_LENGTH - 1] of Byte;
    TIV  = array[0..EVP_MAX_IV_LENGTH - 1] of Byte;
  private var
    FCipherContext: EVP_CIPHER_CTX;
    FSecretKey: string;
    FOrigin: IString;
    FOut: IString;
  private
    function AESEncrypt: string;
  public
    constructor Create(const Origin: IString; const SecretKey: string);
    class function New(const Origin: IString; const SecretKey: string): IString;
    function Value: string;
  end;

implementation

uses
    Obj.SSI.TBase64
  , Obj.SSI.TValue
  , SysUtils
  , LibEay32
  ;

{ TAES }

function TAES128.Value: string;
begin
  Result := FOut.Value;
end;

constructor TAES128.Create(const Origin: IString; const SecretKey: string);
begin
  FSecretKey := SecretKey;
  FOrigin    := Origin;
  FOut       := TString.NewDelayed(AESEncrypt);
end;

class function TAES128.New(const Origin: IString; const SecretKey: string): IString;
begin
  Result := Create(Origin, SecretKey);
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
  LibEAY32.OpenSSL_Add_All_Algorithms;

  Cipher := EVP_get_cipherbyname(PAnsiChar(AnsiString('aes-128-ecb')));
  FillChar(Key, SizeOf(TKey), 0);
  EVP_CipherInit_ex(@FCipherContext, Cipher, nil, PByte(@Key), nil, -1);
  EVP_CipherInit_ex(@FCipherContext, nil, nil, nil, nil, 1);
  SecretKey := RawByteString(FSecretKey);
  if Length(SecretKey) < EVP_CIPHER_CTX_key_length(@FCipherContext)
    then raise Exception.Create('Key length too short');
  EVP_CipherInit_ex(@FCipherContext, nil, nil, Pointer(SecretKey), nil, -1);
  StrIn := RawByteString(FOrigin.Value);
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
      TValue<AnsiString>.New(
        StrOut1 + StrOut2
      )
    ).Value
  );
  EVP_CIPHER_CTX_free(@FCipherContext);
end;

end.
