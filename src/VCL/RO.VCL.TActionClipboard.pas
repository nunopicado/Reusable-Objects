(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IClipboard                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TActionClipboard                                         **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Implements IClipboard, allowing the user to run an       **)
(**                 an action after copying a value                          **)
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

unit RO.VCL.TActionClipboard;

interface

uses
    RO.IClipboard
  , SysUtils
  ;

type
  TActionClipBoard = class(TInterfacedObject, IClipBoard)
  private
    FPostAction: TProc<string>;
  public
    constructor Create(const PostAction: TProc<string>);
    class function New(const PostAction: TProc<string>): IClipBoard;
    function Copy(Value: string): IClipboard;
    function Paste: string;
  end;

implementation

uses
    Vcl.Clipbrd
  , Vcl.Dialogs
  ;

{ TActionClipBoard }

function TActionClipBoard.Copy(Value: string): IClipboard;
begin
  Result            := Self;
  Clipboard.AsText  := Value;
  FPostAction(Value);
end;

constructor TActionClipBoard.Create(const PostAction: TProc<string>);
begin
  FPostAction := PostAction;
end;

class function TActionClipBoard.New(const PostAction: TProc<string>): IClipBoard;
begin
  Result := Create(PostAction);
end;

function TActionClipBoard.Paste: string;
begin
  Result := Clipboard.AsText;
end;

end.
