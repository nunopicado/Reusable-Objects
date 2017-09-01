(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IFile                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IFile                                                    **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Opens a file for reading, gets its content and info      **)
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

unit Obj.SSI.IFile;

interface

uses
    Obj.SSI.IDataStream
  ;

type
  IFile = interface(IInvokable)
  ['{22841154-9E5C-4D64-8780-5FA2C29B4988}']
    function Size: Int64;
    function Created: TDateTime;
    function Modified: TDateTime;
    function Accessed: TDateTime;
    function Version(const Full: Boolean = True): string;
    function AsDataStream: IDataStream;
  end;

implementation

end.
