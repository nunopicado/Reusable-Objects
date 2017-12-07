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
  , RO.IValue
  , Androidapi.JNI.Telephony
  , Androidapi.JNI.JavaTypes
  , Androidapi.JNI.App
  , Androidapi.JNI.GraphicsContentViewText
  , BroadcastReceiver
  ;

type
  TSMS = class(TInterfacedObject, ISMS)
  private const
    cSentAction       = 'SMS_SENT_ACTION';
    cDeliveredAction  = 'SMS_DELIVERED_ACTION';
    cDestinationExtra = 'SMS_PHONE_NUMBER';
  private var
    FMsg: JString;
    FReport: ISMSReport;
    FSmsMgr: JSmsManager;
    FSentIntent: IValue<JIntent>;
    FDeliveredIntent: IValue<JIntent>;
    FPendingSentIntent: IValue<JPendingIntent>;
    FPendingDeliveredIntent: IValue<JPendingIntent>;
    FBroadcast: TBroadcastReceiver;
  private
    procedure OnReceiveBroadCast(aContext: JContext; aIntent: JIntent; aResultCode: Integer);
    procedure ReportSendAction(const Destination: string; const aResultCode: Integer);
    procedure ReportDeliveryAction(const Destination: string; const aResultCode: Integer);
  public
    constructor Create(const Msg: string; const Report: ISMSReport = nil);
    class function New(const Msg: string; const Report: ISMSReport = nil): ISMS;
    function Send(const Destination: string): ISMS;
  end;

implementation

uses
    RO.TValue
  , RO.TIf
  , Androidapi.Helpers
  , FMX.Helpers.Android
  , Androidapi.JNIBridge
  , Androidapi.JNI.Embarcadero
  ;

{ TSMS }

constructor TSMS.Create(const Msg: string; const Report: ISMSReport = nil);
begin
  FMsg    := StringToJString(Msg);
  FReport := Report;
  FSmsMgr := TJSmsManager.JavaClass.getDefault;

  FSentIntent := TValue<JIntent>.New(
    function : JIntent
    begin
      Result := TJIntent.Create;
      Result.setAction(
        StringToJString(cSentAction)
      );
    end
  );

  FPendingSentIntent := TValue<JPendingIntent>.New(
    function : JPendingIntent
    begin
      Result := TJPendingIntent.JavaClass.getBroadcast(
        TAndroidHelper.Context,
        0,
        FSentIntent.Value,
        0
      );
    end
  );

  FDeliveredIntent := TValue<JIntent>.New(
    function : JIntent
    begin
      Result := TJIntent.Create;
      Result.setAction(
        StringToJString(cDeliveredAction)
      );
    end
  );

  FPendingDeliveredIntent := TValue<JPendingIntent>.New(
    function : JPendingIntent
    begin
      Result := TJPendingIntent.JavaClass.getBroadcast(
        TAndroidHelper.Context,
        0,
        FDeliveredIntent.Value,
        0
      );
    end
  );

  FBroadcast := TBroadcastReceiver.Create(OnReceiveBroadcast);
  FBroadcast.AddActions(
    [
      StringToJString(cSentAction),
      StringToJString(cDeliveredAction)
    ]
  );
end;

class function TSMS.New(const Msg: string; const Report: ISMSReport = nil): ISMS;
begin
  Result := Create(Msg, Report);
end;

procedure TSMS.OnReceiveBroadCast(aContext: JContext; aIntent: JIntent; aResultCode: integer);
var
  Destination: string;
begin
  Destination := JStringToString(
    aIntent.getStringExtra(
      StringToJString(cDestinationExtra)
    )
  );
  if JStringToString(aIntent.getAction) = cSentAction
    then ReportSendAction(Destination, aResultCode)
    else ReportDeliveryAction(Destination, aResultCode);
end;

procedure TSMS.ReportDeliveryAction(const Destination: string; const aResultCode: Integer);
begin
  if Assigned(FReport)
    then begin
      FReport.Delivered(
        Destination,
        TIf<TSMSDeliveredResultCode>.New(
          aResultCode = TJActivity.JavaClass.RESULT_OK,
          drcDelivered,
          drcCanceled
        ).Eval
      );
    end;
end;

procedure TSMS.ReportSendAction(const Destination: string; const aResultCode: Integer);
var
  ResultCode: TSMSSentResultCode;
begin
  ResultCode   := srcUnknown;
  if aResultCode = TJActivity.JavaClass.RESULT_OK
    then ResultCode := srcSent;
  if aResultCode = TJSmsManager.JavaClass.RESULT_ERROR_RADIO_OFF
    then ResultCode := srcRadioOff;
  if aResultCode = TJSmsManager.JavaClass.RESULT_ERROR_GENERIC_FAILURE
    then ResultCode := srcGenericFailure;
  if aResultCode = TJSmsManager.JavaClass.RESULT_ERROR_NO_SERVICE
    then ResultCode := srcNoService;
  if aResultCode = TJSmsManager.JavaClass.RESULT_ERROR_NULL_PDU
    then ResultCode := srcNullPDU;
  if Assigned(FReport)
    then FReport.Sent(Destination, ResultCode);
end;

function TSMS.Send(const Destination: string): ISMS;
var
  smsTo: JString;
  PendingSentIntent: JPendingIntent;
  PendingDeliveredIntent: JPendingIntent;
begin
  Result := Self;

  FSentIntent.Value.putExtra(
    StringToJString(cDestinationExtra),
    StringToJString(Destination)
  );
  FDeliveredIntent.Value.putExtra(
    StringToJString(cDestinationExtra),
    StringToJString(Destination)
  );

  smsTo := StringToJString(Destination);
  FSmsMgr.sendTextMessage(
    smsTo,
    nil,
    FMsg,
    FPendingSentIntent.Value,
    FPendingDeliveredIntent.Value
  );
end;

end.
