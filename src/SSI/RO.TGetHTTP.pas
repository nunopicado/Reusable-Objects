(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TGetHTTP                                                 **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Performs a GET action on a given URL                     **)
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

unit RO.TGetHTTP;

interface

uses
    RO.IURL
  , RO.IValue
  ;

type
  TGetHTTP = class(TInterfacedObject, IString)
  private
    FText: IString;
  public
    constructor Create(const URL: IURL);
    class function New(const URL: IURL): IString; overload;
    class function New(const URL: string): IString; overload;
    function Value: string;
    function Refresh: IString;
  end;

implementation

uses
    RO.TValue
  , RO.TURL
  , idHTTP
  , Classes
  , SysUtils
  ;

{ TGetHTTP }

constructor TGetHTTP.Create(const URL: IURL);
resourcestring
  cInvalidURL = 'Invalid URL';
begin
  if not URL.IsValid
    then raise Exception.Create(cInvalidURL);

  FText := TString.New(
    function : string
    var
      HTTP : TidHTTP;
      ss   : TStringStream;
    begin
      HTTP := TidHTTP.Create(nil);
      ss   := TStringStream.Create;
      try
        HTTP.Get(URL.AsString, ss);
        Result := ss.DataString;
      finally
        HTTP.Free;
        ss.Free;
      end;
    end
  );
end;

class function TGetHTTP.New(const URL: IURL): IString;
begin
  Result := Create(URL);
end;

class function TGetHTTP.New(const URL: string): IString;
begin
  Result := New(
    TURL.New(URL)
  );
end;

function TGetHTTP.Refresh: IString;
begin
  Result := Self;
  FText.Refresh;
end;

function TGetHTTP.Value: string;
begin
  Result := FText.Value;
end;

end.
