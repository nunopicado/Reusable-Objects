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
      const DataBits: TDataBits; const StopBits: TStopBits; const FlowControl: TFlowControl;
      const ReadInterval: Word): ICOMPort;  overload;
    class function New(const Port: Byte; const PortSettings: string): ICOMPort; overload;
    function Open: Boolean;
    function Close: ICOMPort;
    function ReadStr(const Action: TProc<string>): ICOMPort;
    function WriteStr(const Str: string): ICOMPort;
  end;

implementation

uses
    RO.IValue
  , RO.TValue
  , Classes
  ;

type
  TCOMSettings = class
  private const
    cBaudRate    = '110,300,600,1200,2400,4800,9600,14400,19200,38400,56000,57600,115200,128000,256000,';
    cParityBits  = 'NOEMS'; // None, Odd, Even, Mark, Space
    cStopBits    = '152';   // One, Five, Two
    cFlowControl = 'HSN';   // Hardware, Software, None
  private var
    FBaudRate: IValue<TBaudRate>;
    FParityBits: IValue<TParityBits>;
    FDataBits: IValue<TDataBits>;
    FStopBits: IValue<TStopBits>;
    FFlowControl: IValue<TFlowControl>;
    FReadInterval: IByte;
  public
    constructor Create(const COMSettings: string);
    function BaudRate: TBaudRate;
    function ParityBits: TParityBits;
    function DataBits: TDataBits;
    function StopBits: TStopBits;
    function FlowControl: TFlowControl;
    function ReadInterval: Byte;
  end;

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

class function TCOMPort.New(const Port: Byte; const PortSettings: string): ICOMPort;
begin
  with TCOMSettings.Create(PortSettings) do
    try
      Result := New(
        Port,
        BaudRate,
        ParityBits,
        DataBits,
        StopBits,
        FlowControl,
        ReadInterval
      );
    finally
      Free;
    end

end;

{ TCOMSettings }

function TCOMSettings.BaudRate: TBaudRate;
begin
  Result := FBaudRate.Value;
end;

constructor TCOMSettings.Create(const COMSettings: string);
begin
  with TStringList.Create do
    begin
      Delimiter       := ',';
      StrictDelimiter := True;
      DelimitedText   := COMSettings;
      while Count < 6 do
        Add('');

      FBaudRate := TValue<TBaudRate>.New(
        function : TBaudRate
        begin
          Result := TBaudRate(
            Pos(
              ValueFromIndex[0] + ',',
              cBaudRate
            ) div 7 + 1
          );
        end
      );

      FParityBits := TValue<TParityBits>.New(
        function : TParityBits
        begin
          Result := TParityBits(
            Pos(
              UpperCase(ValueFromIndex[1]),
              cParityBits
            ) - 1
          );
        end
      );

      FDataBits := TValue<TDataBits>.New(
        function : TDataBits
        begin
          Result := TDataBits(
            StrToInt(
              ValueFromIndex[2]
            ) - 5
          );
        end
      );

      FStopBits := TValue<TStopBits>.New(
        function : TStopBits
        begin
          Result := TStopBits(
            Pos(
              ValueFromIndex[3],
              cStopBits
            ) - 1
          );
        end
      );

      FFlowControl := TValue<TFlowControl>.New(
        function : TFlowControl
        begin
          Result := TFlowControl(
            Pos(
              UpperCase(ValueFromIndex[4]),
              cFlowControl
            ) - 1
          );
        end
      );

      FReadInterval := TByte.New(
        function : Byte
        begin
          Result := StrToInt(
            ValueFromIndex[5]
          );
        end
      );

      Free;
    end;
end;

function TCOMSettings.DataBits: TDataBits;
begin
  Result := FDataBits.Value;
end;

function TCOMSettings.FlowControl: TFlowControl;
begin
  Result := FFlowControl.Value;
end;

function TCOMSettings.ParityBits: TParityBits;
begin
  Result := FParityBits.Value;
end;

function TCOMSettings.ReadInterval: Byte;
begin
  Result := FReadInterval.Value;
end;

function TCOMSettings.StopBits: TStopBits;
begin
  Result := FStopBits.Value;
end;

end.
