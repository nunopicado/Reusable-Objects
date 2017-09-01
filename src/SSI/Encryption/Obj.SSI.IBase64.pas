(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IBase64                                                  **)
(** Framework     : Indy                                                     **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IBase64                                                  **)
(******************************************************************************)
(** Dependencies  : RTL, Indy                                                **)
(******************************************************************************)
(** Description   : Encodes/Decodes To/From Base64 strings                   **)
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

unit Obj.SSI.IBase64;

interface

uses
    Obj.SSI.IValue
  ;

type
  IBase64 = interface(IInvokable)
  ['{B8422767-272C-4BB3-9804-FC9ACBD22FBE}']
    function Encode: AnsiString;
    function Decode: AnsiString;
  end;

  IBase64Factory = interface(IInvokable)
  ['{5C3BBD8B-199E-480D-ABC8-DFABF9D922A1}']
    function New(const Text: IValue<AnsiString>): IBase64; overload;
    function New(const Text: AnsiString): IBase64; overload;
  end;

implementation

end.
