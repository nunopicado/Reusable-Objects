(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPrinters                                                **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPrinters                                                **)
(******************************************************************************)
(** Dependencies  : RTL, WinSpool                                            **)
(******************************************************************************)
(** Description   : Represents the list of printers registered in the        **)
(**                 Windows Spooler. Can send direct escape sequences to a   **)
(**                 printer                                                  **)
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

unit Obj.VCL.IPrinters;

interface

uses
    Obj.SSI.IValue
  , Spring.Collections
  ;

type
  IPrinters = interface
  ['{AD15718B-BFAD-4094-87A5-440C430A5709}']
    function SendSequence(const Sequence: IList<Byte>): IPrinters;
    function AsList(const List: IList<String>): IPrinters;
    function Select(const Name: IString): IPrinters;
    function Default: IString;
  end;

implementation

end.
