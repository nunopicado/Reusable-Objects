(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IShell                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IShell, IShellOutput                                     **)
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
(** Dependencies  : Spring4D                                                 **)
(******************************************************************************)
(** Description   : Represents a shell session, where commands can be        **)
(**                 executed                                                 **)
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

unit RO.IShell;

interface

uses
    Spring.Collections
  , RO.TTriplet
  , Windows
  ;

type
  IShellOutput = interface(IInvokable)
  ['{1036C914-48E2-4409-9DBE-40E7ED99B0DF}']
    function WriteLn(const Line: string): IShellOutput;
  end;

  IShell = interface(IInvokable)
  ['{F09FA6EF-24C8-4D5A-880B-E7EB7045EE15}']
    function Run(const Command: string; const Params: string = ''): Boolean;
    function History: IEnumerable<TTriplet<string, string, Boolean>>;
  end;

implementation

end.
