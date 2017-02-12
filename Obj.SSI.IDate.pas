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

unit Obj.SSI.IDate;

interface

type
    IDate = Interface ['{26A4BD5E-9220-4687-B246-87A8060A277E}']
      function Value    : TDateTime;
      function AsString : String;
      function Age      : LongWord;
    End;

    TDate = Class(TInterfacedObject, IDate)
    private
      FDate: TDateTime;
      constructor Create(aDate: TDateTime);
    public
      class function New(aDate: TDateTime) : IDate; Overload;
      class function New(aDate: String)    : IDate; Overload;
      function Value    : TDateTime;
      function AsString : String;
      function Age      : LongWord;
    End;

    TDecorableDate = Class(TInterfacedObject, IDate)
    protected
      FOrigin: IDate;
    private
      constructor Create(Origin: IDate);
    public
      class function New(Origin: IDate): IDate; Virtual;
      function Value     : TDateTime; Virtual;
      function AsString  : String;    Virtual;
      function Age       : LongWord;  Virtual;
    End;

implementation

uses
    SysUtils
  , DateUtils
  , Variants
  ;

{ TDate }

function TDate.Age: LongWord;
begin
      Result := YearsBetween(Date, FDate);
end;

function TDate.AsString: String;
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

class function TDate.New(aDate: String): IDate;
begin
     Result := New(VarToDateTime(aDate));
end;

function TDate.Value: TDateTime;
begin
     Result := FDate;
end;

{ TDecorableDate }

function TDecorableDate.AsString: String;
begin
     Result := FOrigin.AsString;
end;

constructor TDecorableDate.Create(Origin: IDate);
begin
     FOrigin := Origin;
end;

function TDecorableDate.Age: LongWord;
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

end.

