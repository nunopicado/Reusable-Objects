(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : ICryptString                                             **)
(** Framework     : JEDI JWA WinAPI                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICryptString                                             **)
(** Classes       : TCryptString, implements ICryptString                    **)
(******************************************************************************)
(** Dependencies  : IBase64                                                  **)
(**               : RTL, Jedi JWA WinAPI                                     **)
(******************************************************************************)
(** Description   : Handles Currency values and calculations                 **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**					terms													 **)
(******************************************************************************)

unit Obj.SSI.ICryptString;

interface

type
    ICryptString = interface ['{98C9E3C7-230A-4718-9BB8-0E0B1B40BBE5}']
      function Crypt: ICryptString;
      function Decrypt: ICryptString;
      function Reset: ICryptString;
      function ToString: String;
    end;

    TCryptString = Class(TInterfacedObject, ICryptString)
    private
      const
           BufferSize = 1024 * 1024;
           DefaultPassword = '98C9E3C7';
      var
         FPassword: AnsiString;
         FText: String;
         FResult: String;
      procedure CryptString(var Text: String);
      procedure DecryptString(var Text: String);
    public
      constructor Create(Text: String; Password: AnsiString); Overload;
      constructor Create(Text: String); Overload;
      class function New(Text: String): ICryptString; Overload;
      class function New(Text: String; Password: AnsiString): ICryptString; Overload;
      function Crypt: ICryptString;
      function Decrypt: ICryptString;
      function Reset: ICryptString;
      function ToString: String;
    End;

implementation

uses
    SysUtils
  , Classes
  , JwaWinCrypt
  , JwaWinType
  , Obj.SSI.IBase64
  ;

type
    ICryptKey = Interface ['{A1425CC8-66B2-4367-BFC9-CC2A3A549E57}']
      function Key: HCryptKey;
    End;

    TCryptKey = Class(TInterfacedObject, ICryptKey)
    private
      FPassword: AnsiString;
      FProv: HCryptProv;
      FHash: HCryptHash;
      FKey: HCryptKey;
    public
      constructor Create(Password: AnsiString); Overload;
      destructor Destroy; Override;
      class function New(Password: AnsiString): ICryptKey;
      function Key: HCryptKey;
    End;

{ TCryptString }

constructor TCryptString.Create(Text: String);
begin
     Create(Text, DefaultPassword);
     FText := Text;
     Reset;
end;

constructor TCryptString.Create(Text: String; Password: AnsiString);
begin
     inherited Create;
     FText     := Text;
     FPassword := Password;
     Reset;
end;

function TCryptString.Crypt: ICryptString;
begin
     Result := Self;
     CryptString(FResult);
end;

function TCryptString.Decrypt: ICryptString;
begin
     Result := Self;
     DecryptString(FResult);
end;

class function TCryptString.New(Text: String): ICryptString;
begin
     Result := Create(Text);
end;

function TCryptString.Reset: ICryptString;
begin
     Result  := Self;
     FResult := FText;
end;

function TCryptString.ToString: String;
begin
     Result := FResult;
end;

procedure TCryptString.CryptString(var Text: String);
var
   Source    : TStringStream;
   Target    : TStringStream;
   Buffer    : LPBYTE;
   BytesIn   : DWORD;
   Last      : Boolean;
   FCryptKey : ICryptKey;
begin
     FCryptKey       := TCryptKey.New(FPassword);
     Source          := TStringStream.Create(Text);
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

           // encode the string using base64
           Text := TBase64.New(Target.DataString).Encode.ToString;
        finally
           FreeMem(Buffer, BufferSize);
        end;
     finally
        Source.Free;
        Target.Free;
     end;
end;

procedure TCryptString.DecryptString(var Text: String);
var
   Source    : TStringStream;
   Target    : TStringStream;
   Buffer    : LPBYTE;
   BytesIn   : DWORD;
   Last      : Boolean;
   FCryptKey : ICryptKey;
begin
     FCryptKey       := TCryptKey.New(FPassword);
     Source          := TStringStream.Create(TBase64.New(Text).Decode.ToString);
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
           Text := Target.DataString;
        finally
           FreeMem(Buffer, BufferSize);
        end;
     finally
        Source.Free;
        Target.Free;
     end;
end;

class function TCryptString.New(Text: String;
  Password: AnsiString): ICryptString;
begin
     Result := Create(Text, Password);
end;

{ TCryptKey }

constructor TCryptKey.Create(Password: AnsiString);
begin
     inherited Create;
     FPassword := Password;

     CryptAcquireContext(FProv, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT);
     if not CryptCreateHash(FProv, CALG_SHA1, 0, 0, FHash)
        then RaiseLastOSError;
     try
        if not CryptHashData(FHash, @FPassword[1], Length(FPassword), 0)
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

class function TCryptKey.New(Password: AnsiString): ICryptKey;
begin
     Result := Create(Password);
end;

end.
