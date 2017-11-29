(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ITimer                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TTimer, implements ITimer                                **)
(******************************************************************************)
(** Dependencies  : VCL                                                      **)
(******************************************************************************)
(** Description   : Runs an action repeatedly in a timer                     **)
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

unit RO.VCL.TTimer;

interface

uses
    RO.VCL.ITimer
  , SysUtils
  , VCL.ExtCtrls
  ;

type
  TTimer = class(TInterfacedObject, ITimer)
  private var
    FTimer: VCL.ExtCtrls.TTimer;
    FAction: TProc;
  private
    procedure RunAction(Sender: TObject);
  public
    constructor Create(const Interval: Cardinal);
    destructor Destroy; override;
    class function New(const Interval: Cardinal): ITimer;
    function Start(const Action: TProc): ITimer;
    function Stop: ITimer;
  end;

implementation

{ TTimer }

constructor TTimer.Create(const Interval: Cardinal);
begin
  FTimer          := VCL.ExtCtrls.TTimer.Create(nil);
  FTimer.Enabled  := False;
  FTimer.Interval := Interval;
  FTimer.OnTimer  := RunAction;
end;

destructor TTimer.Destroy;
begin
  FTimer.Free;
  inherited;
end;

class function TTimer.New(const Interval: Cardinal): ITimer;
begin
  Result := Create(Interval);
end;

procedure TTimer.RunAction(Sender: TObject);
begin
  FAction;
end;

function TTimer.Start(const Action: TProc): ITimer;
begin
  Result         := Self;
  FAction        := Action;
  FTimer.Enabled := True;
end;

function TTimer.Stop: ITimer;
begin
  Result         := Self;
  FTimer.Enabled := False;
end;

end.
