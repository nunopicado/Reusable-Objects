(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICOMPort                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TCOMPort                                                 **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : ComPort, VCL                                             **)
(******************************************************************************)
(** Description   : Sends and receives strings from a COM port               **)
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

unit RO.VCL.TCOMPort;

interface

uses
    RO.ICOMPort
  , CPort
  , SysUtils
  ;

type
  TBaudRate    = CPort.TBaudRate;
  TStopBits    = CPort.TStopBits;
  TDataBits    = CPort.TDataBits;
  TParityBits  = CPort.TParityBits;
  TFlowControl = CPort.TFlowControl;

  TCOMPort = class(TInterfacedObject, ICOMPort)
  private
    FPort: CPort.TCOMPort;
    FOnRxChar: TProc<string>;
    procedure DataReception(Sender: TObject; Count: Integer);
  public
    constructor Create(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
      const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl; const ReadInterval: Word);
    destructor Destroy; override;
    class function New(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
      const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl; const ReadInterval: Word): ICOMPort;
    function Open: Boolean;
    function Close: ICOMPort;
    function ReadStr(const Action: TProc<string>): ICOMPort;
    function WriteStr(const Str: string): ICOMPort;
  end;

implementation

{ TCOMPort }

class function TCOMPort.New(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
  const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl;
  const ReadInterval: Word): ICOMPort;
begin
  Result := Create(
    Port,
    BaudRate,
    ParityBits,
    DataBits,
    StopBits,
    FlowControl,
    ReadInterval
  );
end;

constructor TCOMPort.Create(const Port: Byte; const BaudRate: TBaudRate; const ParityBits: TParityBits;
  const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl; const ReadInterval: Word);
begin
  FPort                         := CPort.TComPort.Create(nil);
  FPort.Port                    := Format('COM%d', [Port]);
  FPort.BaudRate                := BaudRate;
  FPort.Parity.Bits             := ParityBits;
  FPort.DataBits                := DataBits;
  FPort.StopBits                := StopBits;
  FPort.FlowControl.FlowControl := FlowControl;
  FPort.Timeouts.ReadInterval   := ReadInterval;
end;

function TCOMPort.Open: Boolean;
begin
  FPort.Connected := True;
  Result          := FPort.Connected;
  if FPort.Connected
    then FPort.Open;
end;

function TCOMPort.ReadStr(const Action: TProc<string>): ICOMPort;
begin
  Result    := Self;
  FOnRxChar := Action;
  if Assigned(FOnRxChar)
    then FPort.OnRxChar := DataReception;
end;

procedure TCOMPort.DataReception(Sender: TObject; Count: Integer);
var
  Str: string;
begin
  FPort.ReadStr(Str, Count);
  FOnRxChar(Str);
end;

function TCOMPort.WriteStr(const Str: string): ICOMPort;
begin
  Result := Self;
  FPort.WriteStr(Str);
end;

function TCOMPort.Close: ICOMPort;
begin
  Result := Self;
  if FPort.Connected
    then begin
      FPort.Close;
      FPort.Connected := False;
    end;
end;

destructor TCOMPort.Destroy;
begin
  FPort.Free;
  inherited;
end;

end.
