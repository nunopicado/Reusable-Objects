(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IIntegerRange, IFloatRange, ICharRange                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IIntegerRange, IFloatRange, ICharRange                   **)
(** Classes       : TIntegerRange, implements IIntegerRange                  **)
(**                 TFloatRange, implements IFloatRange                      **)
(**                 TCharRange, implements ICharRange                        **)
(**                 TAggregatedIntegerRange, decorates IIntegerRange with    **)
(**                   TAggregatedObject                                      **)
(**                 TAggregatedFloatRange, decorates IFloatRange with        **)
(**                   TAggregatedObject                                      **)
(**                 TAggregatedCharRange, decorates ICharRange with          **)
(**                   TAggregatedObject                                      **)
(**                 TRange, implements IIntegerRange, IFloatRange and        **)
(**                   ICharRange, delegating implementation to               **)
(**                   TAggregatedIntegerRange, TAggregatedFloatRange and     **)
(**                   TAggregatedCharRange                                   **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Represents an ordinal value range (Integer, Float or     **)
(**                 char, and allows questioning the range about the         **)
(**                 existence or inexistence of a value inside that range    **)
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

unit Obj.SSI.TRange;

interface

uses
    Obj.SSI.IRange
  ;

type
  TAggregatedIntegerRange = Class(TAggregatedObject, IIntegerRange)
  strict private
    FOrigin: IIntegerRange;
  public
    constructor Create(const Origin: IIntegerRange);
    function Includes(const Value: Int64): Boolean;
    function Excludes(const Value: Int64): Boolean;
  End;

  TIntegerRange = Class(TInterfacedObject, IIntegerRange)
  strict private
    FLow  : Int64;
    FHigh : Int64;
  public
    constructor Create(const LowValue, HighValue: Int64);
    class function New(const LowValue, HighValue: Int64): IIntegerRange;
    function Includes(const Value: Int64): Boolean;
    function Excludes(const Value: Int64): Boolean;
  End;

  TAggregatedFloatRange = Class(TAggregatedObject, IFloatRange)
  strict private
    FOrigin: IFloatRange;
  public
    constructor Create(const Origin: IFloatRange);
    function Includes(const Value: Extended): Boolean;
    function Excludes(const Value: Extended): Boolean;
  End;

  TFloatRange = Class(TInterfacedObject, IFloatRange)
  strict private
    FLow  : Extended;
    FHigh : Extended;
  public
    constructor Create(const LowValue, HighValue: Extended);
    class function New(const LowValue, HighValue: Extended): IFloatRange;
    function Includes(const Value: Extended): Boolean;
    function Excludes(const Value: Extended): Boolean;
  End;

  TAggregatedCharRange = Class(TAggregatedObject, ICharRange)
  strict private
    FOrigin: ICharRange;
  public
    constructor Create(const Origin: ICharRange);
    function Includes(const Value: Char): Boolean;
    function Excludes(const Value: Char): Boolean;
  End;

  TCharRange = Class(TInterfacedObject, ICharRange)
  strict private
    FLow  : Char;
    FHigh : Char;
  public
    constructor Create(const LowValue, HighValue: Char);
    class function New(const LowValue, HighValue: Char): ICharRange;
    function Includes(const Value: Char): Boolean;
    function Excludes(const Value: Char): Boolean;
  End;

  TRange = Class(TInterfacedObject, IIntegerRange, IFloatRange, ICharRange)
  strict private
    FIntegerRange : TAggregatedIntegerRange;
    FFloatRange   : TAggregatedFloatRange;
    FCharRange    : TAggregatedCharRange;
    constructor Create(const LowValue, HighValue: Int64); Overload;
    constructor Create(const LowValue, HighValue: Extended); Overload;
    constructor Create(const LowValue, HighValue: Char); Overload;
  public
    class function New(const LowValue, HighValue: Int64)    : IIntegerRange; Overload;
    class function New(const LowValue, HighValue: Extended) : IFloatRange; Overload;
    class function New(const LowValue, HighValue: Char)     : ICharRange; Overload;
    destructor Destroy; Override;
    property IntegerRange : TAggregatedIntegerRange read FIntegerRange implements IIntegerRange;
    property FloatRange   : TAggregatedFloatRange   read FFloatRange   implements IFloatRange;
    property CharRange    : TAggregatedCharRange    read FCharRange    implements ICharRange;
  End;

implementation

{ TIntegerRange }

constructor TIntegerRange.Create(const LowValue, HighValue: Int64);
begin
  FLow  := LowValue;
  FHigh := HighValue;
end;

function TIntegerRange.Excludes(const Value: Int64): Boolean;
begin
  Result := not Includes(Value);
end;

function TIntegerRange.Includes(const Value: Int64): Boolean;
begin
  Result := (Value >= FLow) and (Value <= FHigh);
end;

class function TIntegerRange.New(const LowValue, HighValue: Int64): IIntegerRange;
begin
  Result := Create(LowValue, HighValue);
end;

{ TFloatRange }

constructor TFloatRange.Create(const LowValue, HighValue: Extended);
begin
  FLow  := LowValue;
  FHigh := HighValue;
end;

function TFloatRange.Excludes(const Value: Extended): Boolean;
begin
  Result := not Includes(Value);
end;

function TFloatRange.Includes(const Value: Extended): Boolean;
begin
  Result := (Value >= FLow) and (Value <= FHigh);
end;

class function TFloatRange.New(const LowValue, HighValue: Extended): IFloatRange;
begin
  Result := Create(LowValue, HighValue);
end;

{ TCharRange }

constructor TCharRange.Create(const LowValue, HighValue: Char);
begin
  FLow  := LowValue;
  FHigh := HighValue;
end;

function TCharRange.Excludes(const Value: Char): Boolean;
begin
  Result := not Includes(Value);
end;

function TCharRange.Includes(const Value: Char): Boolean;
begin
  Result := (Value >= FLow) and (Value <= FHigh);
end;

class function TCharRange.New(const LowValue, HighValue: Char): ICharRange;
begin
  Result := Create(LowValue, HighValue);
end;

{ TRange }

constructor TRange.Create(const LowValue, HighValue: Int64);
begin
  FIntegerRange := TAggregatedIntegerRange.Create(TIntegerRange.Create(LowValue, HighValue));
end;

constructor TRange.Create(const LowValue, HighValue: Extended);
begin
  FFloatRange := TAggregatedFloatRange.Create(TFloatRange.Create(LowValue, HighValue));
end;

constructor TRange.Create(const LowValue, HighValue: Char);
begin
  FCharRange := TAggregatedCharRange.Create(TCharRange.Create(LowValue, HighValue));
end;

destructor TRange.Destroy;
begin
  if Assigned(FIntegerRange)
    then FIntegerRange.Free;
  if Assigned(FFloatRange)
    then FFloatRange.Free;
  if Assigned(FCharRange)
    then FCharRange.Free;
  inherited;
end;

class function TRange.New(const LowValue, HighValue: Int64): IIntegerRange;
begin
  Result := Create(LowValue, HighValue);
end;

class function TRange.New(const LowValue, HighValue: Extended): IFloatRange;
begin
  Result := Create(LowValue, HighValue);
end;

class function TRange.New(const LowValue, HighValue: Char): ICharRange;
begin
  Result := Create(LowValue, HighValue);
end;

{ TDecorableIntegerRange }

constructor TAggregatedIntegerRange.Create(const Origin: IIntegerRange);
begin
  FOrigin := Origin;
end;

function TAggregatedIntegerRange.Excludes(const Value: Int64): Boolean;
begin
  Result := FOrigin.Excludes(Value);
end;

function TAggregatedIntegerRange.Includes(const Value: Int64): Boolean;
begin
  Result := FOrigin.Includes(Value);
end;

{ TDecorableFloatRange }

constructor TAggregatedFloatRange.Create(const Origin: IFloatRange);
begin
  FOrigin := Origin;
end;

function TAggregatedFloatRange.Excludes(const Value: Extended): Boolean;
begin
  Result := FOrigin.Excludes(Value);
end;

function TAggregatedFloatRange.Includes(const Value: Extended): Boolean;
begin
  Result := FOrigin.Includes(Value);
end;

{ TDecorableCharRange }

constructor TAggregatedCharRange.Create(const Origin: ICharRange);
begin
  FOrigin := Origin;
end;

function TAggregatedCharRange.Excludes(const Value: Char): Boolean;
begin
  Result := FOrigin.Excludes(Value);
end;

function TAggregatedCharRange.Includes(const Value: Char): Boolean;
begin
  Result := FOrigin.Includes(Value);
end;

end.
