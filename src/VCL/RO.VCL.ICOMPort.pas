(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICOMPort                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICOMPort                                                 **)
(******************************************************************************)
(** Dependencies  :                                                          **)
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

unit RO.VCL.ICOMPort;

interface

uses
    SysUtils
  ;

type
  ICOMPort = interface(IInvokable)
  ['{9FA1E781-A5E4-43F2-AF56-1C957C4D33F6}']
    function Open: Boolean;
    function Close: ICOMPort;
    function ReadStr(const Action: TProc<string>): ICOMPort;
    function WriteStr(const Str: string): ICOMPort;
  end;

implementation

end.
