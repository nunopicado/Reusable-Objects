(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : INetworkNode                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : INetworkNode                                             **)
(******************************************************************************)
(** Dependencies  : RTL, WinSock                                             **)
(******************************************************************************)
(** Description   : Handles network nodes                                    **)
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

unit RO.INetworkNode;

interface

type
  INetworkNode = interface(IInvokable)
  ['{AF8E8BF2-426E-4FF2-86FE-F577F3B3442D}']
    function IsIPv4Address: Boolean;
    function AsIPv4Address: AnsiString;
    function AsHostname: AnsiString;
    function IsPortOpen(const Port: Word): Boolean;
  end;

implementation

end.
