(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDisplay                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IDisplay                                                 **)
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
(** Description   : Handles communication with a Client Display              **)
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

unit RO.IDisplay;

interface

uses
    Classes
  ;

type
  IDisplay = interface(IInvokable)
  ['{9C8A4084-9E07-47D6-8755-9F415A7BED91}']
    function Connect: IDisplay;
    function ClrScr: IDisplay;
    function ClrLine(const Y: Byte): IDisplay;
    function Write(const Text: string): IDisplay; overload;
    function Write(const Text: string; const Alignment: TAlignment; const Y: Byte): IDisplay; overload;
    function Write(const Text: string; const X, Y: Byte): IDisplay; overload;
    function GotoXY(const X, Y: Byte): IDisplay;
  end;

implementation

end.
