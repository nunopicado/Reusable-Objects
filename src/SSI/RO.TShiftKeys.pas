(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IShiftKeys                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TShiftKeys                                               **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Represents the current state of the computer shift keys  **)
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

unit RO.TShiftKeys;

interface

uses
    RO.IShiftKeys
  , Windows
  ;

type
  TShiftKeys = class(TInterfacedObject, IShiftKeys)
  private
    FState : TKeyboardState;
  public
    constructor Create;
    class function New: IShiftKeys;
    function ShiftDown: Boolean;
    function CtrlDown: Boolean;
    function AltDown: Boolean;
  end;

implementation

{ TShiftKeys }

function TShiftKeys.AltDown: Boolean;
begin
  Result := ((FState[vk_Menu] and 128) <> 0);
end;

constructor TShiftKeys.Create;
begin
  GetKeyboardState(FState);
end;

function TShiftKeys.CtrlDown: Boolean;
begin
  Result := ((FState[vk_Control] and 128) <> 0);
end;

class function TShiftKeys.New: IShiftKeys;
begin
  Result := Create;
end;

function TShiftKeys.ShiftDown: Boolean;
begin
  Result := ((FState[vk_Shift] and 128) <> 0);
end;

end.
