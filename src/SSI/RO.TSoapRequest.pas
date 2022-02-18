(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISoapRequest                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TSoapRequest                                             **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Handles a SOAP request, and its response                 **)
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

unit RO.TSoapRequest;

interface

uses
    SoapHTTPTrans
  , RO.ISoapRequest
  ;

type
  TSoapRequest = class(THTTPReqResp, ISoapRequest)
  public
    constructor Create(const aURL, aAction: string; BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000);
    class function New(const aURL, aAction: string; BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000): ISoapRequest;
    function Send(RequestXML: string): string;
  end;


implementation

uses
    Classes
  ;

{ TSoapRequest }

constructor TSoapRequest.Create(const aURL, aAction: string;
  BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000);
begin
  inherited Create(nil);
  OnBeforePost    := BeforePostEvent;
  URL             := aURL;
  SoapAction      := aAction;
  UseUTF8InHeader := True;
  ConnectTimeout  := TimeOut;
  ReceiveTimeout  := TimeOut;
  SendTimeout     := TimeOut;
end;

class function TSoapRequest.New(const aURL, aAction: string;
  BeforePostEvent: TBeforePostEvent; const TimeOut: Word = 12000): ISoapRequest;
begin
  Result := Create(aURL, aAction, BeforePostEvent);
end;

function TSoapRequest.Send(RequestXML: string): string;
var
  Stream: TStringStream;
begin
  Result := '';
  Stream := TStringStream.Create;
  try
    Execute(RequestXML, Stream);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

end.
