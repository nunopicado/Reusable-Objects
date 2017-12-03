(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IZDate                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TZDate                                                   **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : TZDB                                                     **)
(******************************************************************************)
(** Description   : Returns a XML ready date (ZDate)                         **)
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

unit RO.TZDate;

interface

uses
    RO.IZDate
  , RO.ISNTPTime
  , RO.IValue
  ;

type
  TZDate = class(TInterfacedObject, IZDate)
  private
    FTZInfo: string;
    FSNTPTime: ISNTPTime;
    FZDate: IString;
    function GetZDate: string;
  public
    constructor Create(const TimeZoneInfo: string; const SNTPTime: ISNTPTime);
    class function New(const TimeZoneInfo: string; const SNTPTime: ISNTPTime): IZDate;
    function AsString: string;
  end;

implementation

uses
    RO.TValue
  , Soap.XSBuiltIns
  , DateUtils
  , TZDB
  ;

{ TZDate }

function TZDate.AsString: string;
begin
  Result := FZDate.Value;
end;

constructor TZDate.Create(const TimeZoneInfo: string; const SNTPTime: ISNTPTime);
begin
  FTZInfo   := TimeZoneInfo;
  FSNTPTime := SNTPTime;
  FZDate    := TString.NewDelayed(GetZDate);
end;

function TZDate.GetZDate: string;
var
  XSDate : TXSDatetime;
  TZ     : TTimeZone;
begin
  TZ := TBundledTimeZone.GetTimeZone(FTZInfo);
  XSDate := TXSDatetime.Create;
  try
    XSDate.AsUTCDateTime := TZ.ToUniversalTime(FSNTPTime.Now);
  finally
    Result := XSDate.NativeToXS;
    XSDate.Free;
  end;
end;

class function TZDate.New(const TimeZoneInfo: string; const SNTPTime: ISNTPTime): IZDate;
begin
  Result := Create(TimeZoneInfo, SNTPTime);
end;

end.
