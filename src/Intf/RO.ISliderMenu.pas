(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ISliderMenu                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ISliderMenu, ISliderMenuItem                             **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : A menu that slides from offscreen and back               **)
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

unit RO.ISliderMenu;

interface

uses
    SysUtils
  ;

type
  ISliderMenuItem = interface(IInvokable)
  ['{8760AD2B-B91C-429E-AF6E-5DAE45FB88F5}']
    function Id: Byte;
    function Text: string;
    function SubText: string;
    function ImageIndex: Integer;
    function Action: TProc<Byte>;
  end;

  ISliderMenu = interface(IInvokable)
  ['{8A852B3D-54C8-47B0-9E51-285447A5B93F}']
    function Show: ISliderMenu;
    function Hide: ISliderMenu;
    function Toogle: ISliderMenu;
    function Add(const Item: ISliderMenuItem = nil): ISliderMenu;
    function Resize(const aWidth: Single): ISliderMenu;
    function IsVisible: Boolean;
  end;

implementation

end.
