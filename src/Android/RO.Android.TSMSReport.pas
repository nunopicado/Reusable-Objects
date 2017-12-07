(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISMSReport                                               **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TSMSReport                                               **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : BroadCastReceiver                                        **)
(******************************************************************************)
(** Description   : Handles sent and delivery report for ISMS                **)
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

unit RO.Android.TSMSReport;

interface

uses
    RO.Android.ISMSReport
  , RO.IValue
  , Androidapi.JNI.App
  , Androidapi.JNI.JavaTypes
  , Androidapi.JNI.GraphicsContentViewText
  , BroadcastReceiver
  ;

type
  TSMSReport = class(TInterfacedObject, ISMSReport)
  private const
    cSentAction       = 'SMS_SENT_ACTION';
    cDeliveredAction  = 'SMS_DELIVERED_ACTION';
    cDestinationExtra = 'SMS_PHONE_NUMBER';
  private var
    FMsg: JString;
    FOutput: ISMSReportOutput;
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
    constructor Create(const ReportOutput: ISMSReportOutput);
    class function New(const ReportOutput: ISMSReportOutput): ISMSReport;
    function PendingSentIntent: JPendingIntent;
    function PendingDeliveredIntent: JPendingIntent;
    function Destination(const aDestination: string): string;
  end;

implementation

uses
    RO.TValue
  , RO.TIf
  , Androidapi.Helpers
  , Androidapi.JNI.Telephony
  ;

{ TSMSReport }

constructor TSMSReport.Create(const ReportOutput: ISMSReportOutput);
begin
  FOutput := ReportOutput;

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

function TSMSReport.Destination(const aDestination: string): string;
begin
  FSentIntent.Value.putExtra(
    StringToJString(cDestinationExtra),
    StringToJString(aDestination)
  );
  FDeliveredIntent.Value.putExtra(
    StringToJString(cDestinationExtra),
    StringToJString(aDestination)
  );
end;

class function TSMSReport.New(const ReportOutput: ISMSReportOutput): ISMSReport;
begin
  Result := Create(ReportOutput);
end;

procedure TSMSReport.OnReceiveBroadCast(aContext: JContext; aIntent: JIntent; aResultCode: Integer);
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

function TSMSReport.pendingDeliveredIntent: JPendingIntent;
begin
  Result := FPendingDeliveredIntent.Value;
end;

function TSMSReport.PendingSentIntent: JPendingIntent;
begin
  Result := FPendingSentIntent.Value;
end;

procedure TSMSReport.ReportDeliveryAction(const Destination: string; const aResultCode: Integer);
begin
  if Assigned(FOutput)
    then begin
      FOutput.Delivered(
        Destination,
        TSMSDeliveredResultCode(
          Succ(
            TIf<Integer>.New(
              (aResultCode >= -1) and (aResultCode <= 0),
              aResultCode,
              0
            ).Eval
          )
        )
      )
    end;
end;

procedure TSMSReport.ReportSendAction(const Destination: string; const aResultCode: Integer);
begin
  if Assigned(FOutput)
    then begin
      FOutput.Sent(
        Destination,
        TSMSSentResultCode(
          Succ(
            TIf<Integer>.New(
              (aResultCode >= -1) and (aResultCode <= 4),
              aResultCode,
              0
            ).Eval
          )
        )
      )
    end;
end;

end.
