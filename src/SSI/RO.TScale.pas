(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IScale                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TScale                                                   **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Handles communication with a serial scale                **)
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

unit RO.TScale;

interface

uses
    RO.IScale
  , RO.ITimer
  , RO.ICOMPort
  , RO.IStringMask
  ;

type
  TScale = class(TInterfacedObject, IScale)
  private var
    FOutput: IScaleOutput;
    FPort: IComPort;
    FTXSequence: string;
    FRXMask: IStringMask;
  private
    procedure DataReception(Str: string);
    function ParseScaleData(RxData: string): Real;
  public
    constructor Create(const ScaleOutput: IScaleOutput; const COMPort: ICOMPort; const TXSequence: string;
      const RXMask: IStringMask);
    class function New(const ScaleOutput: IScaleOutput; const COMPort: ICOMPort; const TXSequence: string;
      const RXMask: IStringMask): IScale;
    function Connect: IScale;
    function Disconnect: IScale;
    function Request: IScale;
  end;

  TAutoRequest = class(TInterfacedObject, IScale)
  private var
    FOrigin: IScale;
    FTimer: ITimer;
  private
    procedure RequestTimer;
  public
    constructor Create(const Origin: IScale; const Timer: ITimer);
    class function New(const Origin: IScale; const Timer: ITimer): IScale;
    function Connect: IScale;
    function Disconnect: IScale;
    function Request: IScale;
  end;

implementation

uses
    SysUtils
  , RO.TStringMask
  ;

{ TScale }
{$REGION TScale}
constructor TScale.Create(const ScaleOutput: IScaleOutput; const COMPort: ICOMPort; const TXSequence: string;
  const RXMask: IStringMask);
resourcestring
  ScaleInitError = 'An output implementation is required';
begin
  if not Assigned(ScaleOutput)
    then raise Exception.Create(ScaleInitError);

  FOutput     := ScaleOutput;
  FTXSequence := TXSequence;
  FRXMask     := RXMask;
  FPort       := COMPort.ReadStr(DataReception);
end;

class function TScale.New(const ScaleOutput: IScaleOutput; const COMPort: ICOMPort; const TXSequence: string;
  const RXMask: IStringMask): IScale;
begin
  Result := Create(
    ScaleOutput,
    COMPort,
    TXSequence,
    RXMask
  );
end;

function TScale.Connect: IScale;
begin
  Result := Self;
  FPort.Open;
end;

function TScale.Request: IScale;
begin
  Result := Self;
  FPort.WriteStr(FTXSequence);
end;

procedure TScale.DataReception(Str: string);
begin
  if (not Str.IsEmpty)
      and (Str <> #13#10)
    then begin
      FOutput.ReportWeight(
        ParseScaleData(
          Str
        )
      );
    end;
end;

function TScale.ParseScaleData(RxData: string): Real;
begin
  Result := StrToFloatDef(
    Trim(
      StringReplace(
        FRxMask.Parse(RxData),
        '.',
        FormatSettings.DecimalSeparator,
        [rfReplaceAll]
      )
    ),
    0
  );
end;

function TScale.Disconnect: IScale;
begin
  Result := Self;
  FPort.Close;
end;
{$ENDREGION}

{ TAutoRequest }
{$REGION TAutoRequest}
function TAutoRequest.Connect: IScale;
begin
  Result := Self;
  FOrigin.Connect;
  FTimer.Start(RequestTimer);
end;

procedure TAutoRequest.RequestTimer;
begin
  try
    Request;
  except
    FTimer.Stop;
    raise;
  end;
end;

constructor TAutoRequest.Create(const Origin: IScale; const Timer: ITimer);
begin
  FOrigin := Origin;
  FTimer  := Timer;
end;

function TAutoRequest.Disconnect: IScale;
begin
  Result := Self;
  FOrigin.Disconnect;
end;

class function TAutoRequest.New(const Origin: IScale; const Timer: ITimer): IScale;
begin
  Result := Create(Origin, Timer);
end;

function TAutoRequest.Request: IScale;
begin
  Result := Self;
  FOrigin.Request;
end;
{$ENDREGION}

end.
