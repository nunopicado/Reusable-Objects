(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IURL                                                     **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TURL                                                     **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : WinINet                                                  **)
(******************************************************************************)
(** Description   : Checks if an URL is valid and active                     **)
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

unit RO.TURL;

interface

uses
    RO.IURL
  , RO.IValue
  ;

type
  TURL = class(TInterfacedObject, IURL)
  private
    FURL: string;
    FIsValid: IBoolean;
    function DoCheckURL: Boolean;
  public
    constructor Create(const URL: string);
    class function New(const URL: string): IURL;
    function IsValid: Boolean;
  end;

implementation

uses
    RO.TValue
  , WinINet
  ;

{ TURL }

constructor TURL.Create(const URL: string);
begin
  FURL     := URL;
  FIsValid := TBoolean.NewDelayed(DoCheckURL);
end;

function TURL.DoCheckURL: Boolean;
var
  hSession,
  hFile     : hInternet;
  dwIndex,
  dwCodeLen : Cardinal;
  dwCode    : array [1..20] of Char;
  Res       : PChar;
begin
  Result   := False;
  hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hSession) then begin
    hFile     := InternetOpenUrl(hSession, PChar(FURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
    dwIndex   := 0;
    dwCodeLen := 10;
    HttpQueryInfo(hFile, HTTP_QUERY_STATUS_CODE, @dwCode, dwCodeLen, dwIndex);
    Res       := PChar(@dwCode);
    Result    := (Res = '200') or (Res = '302');
    if assigned(hFile) then
      InternetCloseHandle(hFile);
    InternetCloseHandle(hSession);
  end;
end;

function TURL.IsValid: Boolean;
begin
  Result := FIsValid.Value;
end;

class function TURL.New(const URL: string): IURL;
begin
  Result := Create(URL);
end;

end.
