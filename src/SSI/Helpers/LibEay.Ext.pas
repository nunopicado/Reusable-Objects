(******************************************************************************)
(** Suite         : AtWS                                                     **)
(** Object        :                                                          **)
(** Framework     :                                                          **)
(** Developed by  : DelphiOnRails, extraction of specifics by Nuno Picado    **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Dependencies  : OpenSSL, LibEay32                                        **)
(******************************************************************************)
(** Description   : Extends LibEay32 OpenSSL wrapping                        **)
(******************************************************************************)
(** Licence       : MIT (https://opensource.org/licenses/MIT)                **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**	                terms                                                    **)
(******************************************************************************)

unit LibEay.Ext;

interface

uses
    LibEay32
  ;

const
  cLibEay                 = 'LibEay32.dll';
  EVP_MAX_KEY_LENGTH      = 32;
  EVP_MAX_IV_LENGTH       = 16;
  EVP_MAX_BLOCK_LENGTH    = 32;
  BIO_FLAGS_BASE64_NO_NL  = $100;

type
  TNotImplemented = record end;
  PNotImplemented = ^TNotImplemented;
  PEVP_CIPHER = ^EVP_CIPHER;
  PEVP_CIPHER_CTX = ^EVP_CIPHER_CTX;

  EVP_CIPHER = record
    nid: Integer;
    block_size: Integer;
    key_len: Integer;
    iv_len: Integer;
    flags: LongWord;
    init: function(ctx: PEVP_CIPHER_CTX; const key, iv: PAnsiChar; enc: Integer): Integer; cdecl;
    do_cipher: function(ctx: PEVP_CIPHER_CTX; out_: PAnsiChar; const in_: PAnsiChar; inl: Cardinal): Integer; cdecl;
    cleanup: function(ctx: PEVP_CIPHER_CTX): Integer;
    ctx_size: Integer;
    set_asn1_parameters: function(ctx: PEVP_CIPHER_CTX; ASN1: PNotImplemented): Integer; cdecl;
    get_asn1_parameters: function(ctx: PEVP_CIPHER_CTX; ASN1: PNotImplemented): Integer; cdecl;
    ctrl: function(ctx: PEVP_CIPHER_CTX; type_, arg: Integer; ptr: Pointer): Integer; cdecl;
    app_data: Pointer;
  end;

  EVP_CIPHER_CTX = record
    cipher: PEVP_CIPHER;
    engine: PNotImplemented;
    encrypt: Integer;
    buf_len: Integer;

    oiv: array[0..EVP_MAX_IV_LENGTH-1] of AnsiChar;
    iv: array[0..EVP_MAX_IV_LENGTH-1] of AnsiChar;
    buf: array[0..EVP_MAX_BLOCK_LENGTH-1] of AnsiChar;
    num: Integer;

    app_data: Pointer;
    key_len: Integer;
    flags: LongWord;
    cipher_data: Pointer;
    final_used: Integer;
    block_mask: Integer;
    final: array[0..EVP_MAX_BLOCK_LENGTH-1] of AnsiChar;
	end;

function EVP_CipherInit_ex(ctx: PEVP_CIPHER_CTX; const cipher: PEVP_CIPHER;
  impl: PNotImplemented; const key, iv: PByte; enc: Integer): Integer; cdecl; external cLibEay;
procedure EVP_CIPHER_CTX_free(a: PEVP_CIPHER_CTX); cdecl; external cLibEay;
function EVP_CIPHER_CTX_block_size(const ctx: PEVP_CIPHER_CTX): Integer; cdecl; external cLibEay;
function EVP_CipherUpdate(ctx: PEVP_CIPHER_CTX; out_: Pointer;
  outl: PInteger; const in_: Pointer; inl: Integer): Integer; cdecl; external cLibEay;
function EVP_CipherFinal_ex(ctx: PEVP_CIPHER_CTX; outm: Pointer; outl: PInteger): Integer; cdecl; external cLibEay;
function EVP_CIPHER_CTX_key_length(const ctx: PEVP_CIPHER_CTX): Integer; cdecl; external cLibEay;
procedure BIO_set_flags(b: PBIO; flags: Integer); cdecl; external cLibEay;

implementation

end.
