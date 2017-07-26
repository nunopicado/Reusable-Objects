(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDate                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IDate                                                    **)
(** Classes       : TDate, implements IDate                                  **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
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

unit Obj.SSI.TDate;

interface

uses
    Obj.SSI.IValue
  , Obj.SSI.IDate
  ;

type
  TDate = class(TInterfacedObject, IDate)
  private
    FDate: TDateTime;
  public
    constructor Create(aDate: TDateTime);
    class function New(aDate: TDateTime) : IDate; overload;
    class function New(aDate: string)    : IDate; overload;
    class function New(aDate: IString)   : IDate; overload;
    function Value     : TDateTime;
    function AsIString : IString;
    function Age       : IInteger;
  End;

  TDecorableDate = class(TInterfacedObject, IDate)
  protected
    FOrigin: IDate;
  private
    constructor Create(Origin: IDate);
  public
    class function New(Origin: IDate): IDate; virtual;
    function Value      : TDateTime; virtual;
    function AsIString  : IString;   virtual;
    function Age        : IInteger; virtual;
  end;

  TUTC = class(TDecorableDate, IDate)
  public
    function Value: TDateTime; override;
  end;

  TXMLTime = class(TDecorableDate, IDate)
  private
    const
      cXMLTime = 'yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''.''zzz''Z';
  public
    function AsIString: IString; override;
  end;

  TFormattedDate = class(TDecorableDate, IDate)
  private
    FMask: IString;
    constructor Create(Origin: IDate; Mask: IString); overload;
  public
    class function New(Origin: IDate; Mask: IString): IDate; overload;
    function AsIString: IString; override;
  end;

  TMonthsAge = class(TDecorableDate, IDate)
  public
    function Age: IInteger; override;
  end;

  TWeeksAge = class(TDecorableDate, IDate)
  public
    function Age: IInteger; override;
  end;

  TDaysAge = class(TDecorableDate, IDate)
  public
    function Age: IInteger; override;
  end;

implementation

uses
    SysUtils
  , DateUtils
  , Variants
  , Obj.SSI.TPrimitive
  ;

{ TDate }

function TDate.Age: IInteger;
begin
  Result := TInteger.New(
    YearsBetween(Date, FDate)
  );
end;

function TDate.AsIString: IString;
begin
  Result := TString.New(
   DateToStr(FDate)
  );
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

function TDecorableDate.AsIString: IString;
begin
  Result := FOrigin.AsIString;
end;

constructor TDecorableDate.Create(Origin: IDate);
begin
  FOrigin := Origin;
end;

function TDecorableDate.Age: IInteger;
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

function TXMLTime.AsIString: IString;
begin
  Result := TString.New(
    FormatDateTime(cXMLTime, FOrigin.Value)
  );
end;

{ TFormattedDate }

function TFormattedDate.AsIString: IString;
begin
  Result := TString.New(
    FormatDateTime(FMask.Value, FOrigin.Value)
  );
end;

constructor TFormattedDate.Create(Origin: IDate; Mask: IString);
begin
  FOrigin := Origin;
  FMask   := Mask;
end;

class function TFormattedDate.New(Origin: IDate; Mask: IString): IDate;
begin
  Result := Create(Origin, Mask);
end;

{ TMonthsAge }

function TMonthsAge.Age: IInteger;
begin
  Result := TInteger.New(
    MonthsBetween(Now, FOrigin.Value)
  );
end;

{ TWeeksAge }

function TWeeksAge.Age: IInteger;
begin
  Result := TInteger.New(
    WeeksBetween(Now, FOrigin.Value)
  );
end;

{ TDaysAge }

function TDaysAge.Age: IInteger;
begin
  Result := TInteger.New(
    DaysBetween(Now, FOrigin.Value)
  );
end;

end.

