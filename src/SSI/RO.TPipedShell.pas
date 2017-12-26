(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IShell                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TPipedShell                                              **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring4D                                                 **)
(******************************************************************************)
(** Description   : Executes commands in a shell session, piping the output  **)
(**                 to an IShellOutput                                       **)
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

unit RO.TPipedShell;

interface

uses
    RO.IShell
  , RO.TTriplet
  , Spring.Collections
  ;

type
  TPipedShell = class(TInterfacedObject, IShell)
  private
    FHistory: IList<TTriplet<string, string, Boolean>>;
    FOutput: IShellOutput;
  public
    constructor Create(const Output: IShellOutput);
    class function New(const Output: IShellOutput): IShell;
    function Run(const Command: string; const Params: string = ''): Boolean;
    function History: IEnumerable<TTriplet<string, string, Boolean>>;
  end;

implementation

uses
    ShellAPI
  , Windows
  ;

{ TPipedShell }

constructor TPipedShell.Create(const Output: IShellOutput);
begin
  FHistory := TCollections.CreateList<TTriplet<string, string, Boolean>>;
  FOutput  := Output;
end;

function TPipedShell.History: IEnumerable<TTriplet<string, string, Boolean>>;
begin
  Result := FHistory;
end;

class function TPipedShell.New(const Output: IShellOutput): IShell;
begin
  Result := Create(Output);
end;

function TPipedShell.Run(const Command: string; const Params: string = ''): Boolean;
const
  CReadBuffer = 2400;
var
  saSecurity  : TSecurityAttributes;
  hRead       : THandle;
  hWrite      : THandle;
  suiStartup  : TStartupInfo;
  piProcess   : TProcessInformation;
  pBuffer     : array [0..CReadBuffer] of AnsiChar;
  dRead       : DWord;
  dRunning    : DWord;
begin
  Result := False;
  with saSecurity do
    begin
      nLength              := SizeOf(TSecurityAttributes);
      bInheritHandle       := True;
      lpSecurityDescriptor := nil;
    end;
  if CreatePipe(hRead, hWrite, @saSecurity, 0)
    then begin
      ZeroMemory(@suiStartup, SizeOf(suiStartup));
      with suiStartup do
        begin
          cb           := SizeOf(TStartupInfo);
          hStdInput    := hRead;
          hStdOutput   := hWrite;
          hStdError    := hWrite;
          dwFlags      := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
          wShowWindow  := SW_HIDE;
        end;
      if CreateProcess(
          nil,
          PChar(Command + ' ' + Params),
          @saSecurity,
          @saSecurity,
          True,
          NORMAL_PRIORITY_CLASS,
          nil,
          nil,
          suiStartup,
          piProcess
        )
        then begin
          repeat
            dRunning := WaitForSingleObject(piProcess.hProcess, 100);
            repeat
              dRead := 0;
              ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
              pBuffer[dRead] := #0;
              OemToAnsi(pBuffer, pBuffer);
              FOutput.WriteLn(string(pBuffer));
            until (dRead < CReadBuffer);
          until (dRunning <> WAIT_TIMEOUT);
          CloseHandle(piProcess.hProcess);
          CloseHandle(piProcess.hThread);
          Result := True;
          FHistory.Add(TTriplet<string, string, Boolean>.Create(Command, Params, Result));
        end;
      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;
end;

end.
