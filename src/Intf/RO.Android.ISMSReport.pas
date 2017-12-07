(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISMSReport                                               **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ISMSReport, ISMSReportOutput                             **)
(******************************************************************************)
(** Enumerators   : TSMSSentResultCode, TSMSDeliveredResultCode              **)
(******************************************************************************)
(** Classes       : TSMSReport                                               **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
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

unit RO.Android.ISMSReport;

interface

uses
    Androidapi.JNI.App
  ;

type
  TSMSSentResultCode      = (srcSent, srcUnknown, srcGenericFailure, srcRadioOff, srcNullPDU, srcNoService);
  TSMSDeliveredResultCode = (drcDelivered, drcCanceled);

  ISMSReportOutput = interface(IInvokable)
  ['{BF6D6705-5DCD-4B6E-839B-D9FA24B06406}']
    function Sent(const Destination: string; const ResultCode: TSMSSentResultCode): ISMSReportOutput;
    function Delivered(const Destination: string; const ResultCode: TSMSDeliveredResultCode): ISMSReportOutput;
  end;

  ISMSReport = interface(IInvokable)
  ['{B726CD3F-0A2C-44AA-8530-CFEE6A731B4C}']
    function PendingSentIntent: JPendingIntent;
    function PendingDeliveredIntent: JPendingIntent;
    function Destination(const aDestination: string): string;
  end;

implementation

end.
