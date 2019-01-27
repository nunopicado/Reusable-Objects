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
(** Classes       : TMsgClipboard                                            **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Implements IClipboard, allowing the user to show a       **)
(**                 message after copying a value                            **)
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

unit RO.VCL.TMsgClipboard;

interface

uses
    RO.IClipboard
  , SysUtils
  ;

type
  TMsgClipBoard = class(TInterfacedObject, IClipBoard)
  private
    FOrigin: IClipboard;
  public
    constructor Create(const Msg: string);
    class function New(const Msg: string): IClipBoard; overload;
    function Copy(Value: string): IClipboard;
    function Paste: string;
  end;

implementation

uses
    RO.VCL.TActionClipboard
  , Vcl.Dialogs
  ;

{ TMsgClipBoard }

function TMsgClipBoard.Copy(Value: string): IClipboard;
begin
  Result := Self;
  FOrigin.Copy(Value);
end;

constructor TMsgClipBoard.Create(const Msg: string);
begin
  FOrigin := TActionClipBoard.New(
    procedure (Value: string)
    begin
      ShowMessageFmt(
        Msg,
        [Value]
      );
    end
  );
end;

class function TMsgClipBoard.New(const Msg: string): IClipBoard;
begin
  Result := Create(Msg);
end;

function TMsgClipBoard.Paste: string;
begin
  Result := FOrigin.Paste;
end;

end.
