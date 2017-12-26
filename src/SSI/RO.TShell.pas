(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IShell                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   : TExecutionBehaviour, TRunElevation, TWindowStyle         **)
(******************************************************************************)
(** Classes       : TShell                                                   **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring4D                                                 **)
(******************************************************************************)
(** Description   : Executes commands in a shell session                     **)
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

unit RO.TShell;

interface

uses
    RO.IShell
  , RO.TTriplet
  , Spring.Collections
  ;

type
  TExecutionBehaviour = (ebFreeRun, ebWaitForExecution);
  TRunElevation       = (reUser, reAdmin);
  TWindowStyle        = (wsHide, wsNormal, wsMinimized, wsMaximized);

  TShell = class(TInterfacedObject, IShell)
  private
    FHistory: IList<TTriplet<string, string, Boolean>>;
    FExecutionBehaviour: TExecutionBehaviour;
    FRunElevation: TRunElevation;
    FWindowStyle: TWindowStyle;
  public
    constructor Create(const ExecutionBehaviour: TExecutionBehaviour; const RunElevation: TRunElevation;
      const WindowStyle: TWindowStyle);
    class function New(const ExecutionBehaviour: TExecutionBehaviour; const RunElevation: TRunElevation;
      const WindowStyle: TWindowStyle): IShell;
    function Run(const Command: string; const Params: string = ''): Boolean;
    function History: IEnumerable<TTriplet<string, string, Boolean>>;
  end;

implementation

uses
    ShellAPI
  , Windows
  ;

{ TShell }

constructor TShell.Create(const ExecutionBehaviour: TExecutionBehaviour; const RunElevation: TRunElevation;
  const WindowStyle: TWindowStyle);
begin
  FExecutionBehaviour := ExecutionBehaviour;
  FRunElevation       := RunElevation;
  FWindowStyle        := WindowStyle;
  FHistory            := TCollections.CreateList<TTriplet<string, string, Boolean>>;
end;

function TShell.History: IEnumerable<TTriplet<string, string, Boolean>>;
begin
  Result := FHistory;
end;

class function TShell.New(const ExecutionBehaviour: TExecutionBehaviour; const RunElevation: TRunElevation;
  const WindowStyle: TWindowStyle): IShell;
begin
  Result := Create(ExecutionBehaviour, RunElevation, WindowStyle);
end;

function TShell.Run(const Command: string; const Params: string = ''): Boolean;
var
  SEInfo   : TShellExecuteInfo;
  ExitCode : DWORD;
begin
  Result := False;
  ZeroMemory(@SEInfo, SizeOf(SEInfo));
  with SEInfo do
    begin
      cbSize        := SizeOf(TShellExecuteInfo);
      fMask         := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI or SEE_MASK_NOCLOSEPROCESS;
      lpFile        := PChar(Command);
      lpParameters  := PChar(Params);
      nShow         := Integer(FWindowStyle);
      if FRunElevation = reAdmin
        then lpVerb := PChar('runas');
    end;
  if ShellExecuteEx(@SEInfo)
    then begin
      if FExecutionBehaviour = ebWaitForExecution
        then
          repeat
            GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
          until ExitCode <> STILL_ACTIVE;
      Result := True;
      FHistory.Add(TTriplet<string, string, Boolean>.Create(Command, Params, Result));
    end;
end;

end.
