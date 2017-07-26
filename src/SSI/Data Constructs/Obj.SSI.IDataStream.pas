(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IDataStream                                              **)
(** Framework     :                                                          **)
(** Developed by  : Marcos Douglas Santos, mild adaptation by Nuno Picado    **)
(******************************************************************************)
(** Interfaces    : IDataStream                                              **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Holds a datastream, created from and saved to various    **)
(**                 formats                                                  **)
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

unit Obj.SSI.IDataStream;

interface

uses
    Classes
  ;

type
  IDataStream = interface(IInvokable)
  ['{1ED9FBE5-56F3-45BD-8A84-EA5F4A54CED9}']
    function Save(const Stream: TStream): IDataStream; Overload;
    function Save(const Strings: TStrings): IDataStream; Overload;
    function Save(const FileName: string): IDataStream; Overload;
    function AsString: String;
    function Size: Int64;
  end;

implementation

end.
