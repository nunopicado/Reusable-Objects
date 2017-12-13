(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ICSVString                                               **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : ICSVString                                               **)
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
(** Description   : Represents a comma delimited string                      **)
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

unit RO.ICSVString;

interface

type
  ICSVString = interface(IInvokable)
  ['{3995FCE9-5ED4-49EB-A4BB-6CB6A787CC1A}']
    function Count: Byte;
    function Field(const FieldNumber: Byte; const Default: string = ''): string;
  end;

  ICSVStringFactory = interface(IInvokable)
  ['{4B0630D1-1F19-4F32-BB4E-1CC6B56600C2}']
    function New(const CSVString: string; const Delimiter: Char): ICSVString; overload;
    function New(const CSVString: string): ICSVString; overload;
  end;

implementation

end.
