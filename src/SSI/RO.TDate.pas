(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDate                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TDate                                                    **)
(**                 TDecorableDate                                           **)
(******************************************************************************)
(** Decorators    : TUTC, TXMLTime, TFormattedDate, TMonthsAge, TWeeksAge,   **)
(**                 TDaysAge, TFullDateTime                                  **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Represents a date                                        **)
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

unit RO.TDate;

interface

uses
    RO.IValue
  , RO.IDate
  ;

type
  TDate = class(TInterfacedObject, IDate)
  private var
    FDate: TDateTime;
  public
    constructor Create(aDate: TDateTime);
    class function New(aDate: TDateTime) : IDate; overload;
    class function New(aDate: string)    : IDate; overload;
    class function New(aDate: IString)   : IDate; overload;
    function Value    : TDateTime;
    function AsString : string;
    function Age      : Integer;
  end;

  TDecorableDate = class(TInterfacedObject, IDate)
  protected var
    FOrigin: IDate;
  private
    constructor Create(Origin: IDate);
  public
    class function New(Origin: IDate): IDate; virtual;
    function Value     : TDateTime; virtual;
    function AsString  : string; virtual;
    function Age       : Integer; virtual;
  end;

  TUTC = class(TDecorableDate, IDate)
  public
    function Value: TDateTime; override;
  end;

  TXMLTime = class(TDecorableDate, IDate)
  private const
      cXMLTime = 'yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''.''zzz''Z';
  public
    function AsString: string; override;
  end;

  TFormattedDate = class(TDecorableDate, IDate)
  private var
    FMask: string;
  private
    constructor Create(Origin: IDate; Mask: string); overload;
  public
    class function New(Origin: IDate; Mask: string): IDate; overload;
    class function New(Origin: IDate; Mask: IString): IDate; overload;
    function AsString: string; override;
  end;

  TMonthsAge = class(TDecorableDate, IDate)
  public
    function Age: Integer; override;
  end;

  TWeeksAge = class(TDecorableDate, IDate)
  public
    function Age: Integer; override;
  end;

  TDaysAge = class(TDecorableDate, IDate)
  public
    function Age: Integer; override;
  end;

  TFullDateTime = class(TDecorableDate, IDate)
  public
    function AsString: string; override;
  end;

implementation

uses
    SysUtils
  , DateUtils
  , Variants
  , RO.TValue
  ;

{ TDate }

function TDate.Age: Integer;
begin
  Result := YearsBetween(Date, FDate);
end;

function TDate.AsString: string;
begin
  Result := DateToStr(FDate);
end;

constructor TDate.Create(aDate: TDateTime);
begin
  FDate := aDate;
end;

class function TDate.New(aDate: TDateTime): IDate;
begin
  Result := Create(aDate);
end;

class function TDate.New(aDate: IString): IDate;
begin
  Result := New(aDate.Value);
end;

class function TDate.New(aDate: string): IDate;
begin
  Result := New(
    VarToDateTime(aDate)
  );
end;

function TDate.Value: TDateTime;
begin
  Result := FDate;
end;

{ TDecorableDate }

function TDecorableDate.AsString: string;
begin
  Result := FOrigin.AsString;
end;

constructor TDecorableDate.Create(Origin: IDate);
begin
  FOrigin := Origin;
end;

function TDecorableDate.Age: Integer;
begin
  Result := FOrigin.Age;
end;

class function TDecorableDate.New(Origin: IDate): IDate;
begin
  Result := Create(Origin);
end;

function TDecorableDate.Value: TDateTime;
begin
  Result := FOrigin.Value;
end;

{ TUTC }

function TUTC.Value: TDateTime;
begin
  Result := TTimeZone.Local.ToUniversalTime(inherited);
end;

{ TXMLTime }

function TXMLTime.AsString: string;
begin
  Result := FormatDateTime(cXMLTime, FOrigin.Value);
end;

{ TFormattedDate }

function TFormattedDate.AsString: string;
begin
  Result := FormatDateTime(FMask, FOrigin.Value);
end;

constructor TFormattedDate.Create(Origin: IDate; Mask: string);
begin
  FOrigin := Origin;
  FMask   := Mask;
end;

class function TFormattedDate.New(Origin: IDate; Mask: string): IDate;
begin
  Result := Create(Origin, Mask);
end;

class function TFormattedDate.New(Origin: IDate; Mask: IString): IDate;
begin
  Result := New(Origin, Mask.Value);
end;

{ TMonthsAge }

function TMonthsAge.Age: Integer;
begin
  Result := MonthsBetween(Now, FOrigin.Value);
end;

{ TWeeksAge }

function TWeeksAge.Age: Integer;
begin
  Result := WeeksBetween(Now, FOrigin.Value);
end;

{ TDaysAge }

function TDaysAge.Age: Integer;
begin
  Result := DaysBetween(Now, FOrigin.Value);
end;

{ TFullDateTime }

function TFullDateTime.AsString: string;
begin
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', Value);
end;

end.

