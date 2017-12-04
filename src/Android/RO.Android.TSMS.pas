(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISMS                                                     **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TSMS                                                     **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Handles sending SMS                                      **)
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

unit RO.Android.TSMS;

interface

uses
    RO.ISMS
  , Androidapi.JNI.Telephony
  , Androidapi.JNI.JavaTypes
  ;

type
  TSMS = class(TInterfacedObject, ISMS)
  private
    FMsg: JString;
    FSmsMgr: JSmsManager;
  public
    constructor Create(const Msg: string);
    class function New(const Msg: string): ISMS;
    function Send(const Destination: string): ISMS;
  end;

implementation

uses
    Androidapi.Helpers
  ;

{ TSMS }

constructor TSMS.Create(const Msg: string);
begin
  FMsg    := StringToJString(Msg);
  FSmsMgr := TJSmsManager.JavaClass.getDefault;
end;

class function TSMS.New(const Msg: string): ISMS;
begin
  Result := Create(Msg);
end;

function TSMS.Send(const Destination: string): ISMS;
var
  smsTo: JString;
begin
  Result := Self;
  smsTo  := StringToJString(Destination);
  FSmsMgr.sendTextMessage(
    smsTo,
    nil,
    FMsg,
    nil,
    nil
  );
end;

end.
