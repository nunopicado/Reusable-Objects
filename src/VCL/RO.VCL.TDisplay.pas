(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDisplay                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TDisplay                                                 **)
(******************************************************************************)
(** Dependencies  : VCL, TComPort                                            **)
(******************************************************************************)
(** Description   : Handles communication with a Client Display              **)
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

unit RO.VCL.TDisplay;

interface

uses
    RO.VCL.IDisplay
  , Classes
  , CPort
  ;

type
  TDisplay = class(TInterfacedObject, IDisplay)
    FDisplay: TComPort;
  private const
    cClearCurrentLine     = #$18;
    cClearDisplay         = #$0C;
    cEpsonInitialization  = #$1B#$40;
    cCP860                = #$1B#$52'3';
    cMoveHome             = #$0B;
    cMoveDown             = #$0A;
    cMoveRight            = #$09;
  private var
    FLines: Byte;
    FColumns: Byte;
  public
    constructor Create(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
      const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl;
      const ReadInterval: Word; const Columns, Lines: Byte);
    destructor Destroy; override;
    class function New(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
      const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl;
      const ReadInterval: Word; const Columns, Lines: Byte): IDisplay;
    function Connect: IDisplay;
    function ClrScr: IDisplay;
    function ClrLine(const Y: Byte): IDisplay;
    function Write(const Text: string): IDisplay; overload;
    function Write(const Text: string; const Alignment: TAlignment; const Y: Byte): IDisplay; overload;
    function Write(const Text: string; const X, Y: Byte): IDisplay; overload;
    function GotoXY(const X, Y: Byte): IDisplay;
  end;

implementation

uses
    SysUtils
  , RO.TIf
  ;

{ TDisplay }

function TDisplay.ClrLine(const Y: Byte): IDisplay;
begin
  Result := Self;
  Write(cClearCurrentLine, 1, Y);
end;

function TDisplay.ClrScr: IDisplay;
begin
  Result := Self;
  FPort.WriteStr(cClearDisplay);
end;

function TDisplay.Connect: IDisplay;
begin
  FDisplay.Connected := True;
  if FDisplay.Connected
    then begin
      FDisplay.Open;
      FPort
        .WriteStr(cEpsonInitialization)
        .WriteStr(cCP860);
      ClrScr;
    end;
end;

constructor TDisplay.Create(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
  const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl; const ReadInterval: Word;
  const Columns, Lines: Byte);
begin
  // Display connection
  FDisplay                         := TComPort.Create(nil);
  FDisplay.Port                    := Format('COM%d', [Port]);
  FDisplay.BaudRate                := BaudRate;
  FDisplay.Parity.Bits             := ParityBits;
  FDisplay.DataBits                := DataBits;
  FDisplay.StopBits                := StopBits;
  FDisplay.FlowControl.FlowControl := FlowControl;
  FDisplay.Timeouts.ReadInterval   := ReadInterval;

  FColumns := Columns;
  FLines   := Lines;
end;

destructor TDisplay.Destroy;
begin
  FDisplay.Free;
  inherited;
end;

function TDisplay.GotoXY(const X, Y: Byte): IDisplay;
var
  i:Byte;
begin
  Result := Self;
  FPort.WriteStr(cMoveHome);
  for i := 1 to Pred(Y) do
    FPort.WriteStr(cMoveDown);
  for i := 1 to Pred(X) do
    FPort.WriteStr(cMoveRight);
end;

class function TDisplay.New(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
  const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl; const ReadInterval: Word;
  const Columns, Lines: Byte): IDisplay;
begin
  Result := Create(
    Port,
    BaudRate,
    ParityBits,
    DataBits,
    StopBits,
    FlowControl,
    ReadInterval,
    Columns,
    Lines
  );
end;

function TDisplay.Write(const Text: string; const X, Y: Byte): IDisplay;
begin
  Result := Self;
  GotoXY(X,Y);
  Write(Text);
end;

function TDisplay.Write(const Text: string; const Alignment: TAlignment; const Y: Byte): IDisplay;
begin
  Result := Self;
  Write(
    Text,
    TIf<Integer>.New(
      Alignment = taCenter,
      (FColumns - Text.Length) div 2,
      FColumns - Text.Length
    ).Eval,
    Y
  );
end;

function TDisplay.Write(const Text: string): IDisplay;
begin
  Result := Self;
  FDisplay.WriteStr(Text);
end;

end.
