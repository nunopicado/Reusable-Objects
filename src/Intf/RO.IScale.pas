(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IScale                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IScale, IScaleOutput                                     **)
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
(** Description   : Handles communication with a serial scale                **)
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

unit RO.IScale;

interface

type
  IScaleOutput = interface(IInvokable)
  ['{474D91FE-D458-4272-A61A-22552AF14874}']
    function ReportWeight(const Weight: Double): IScaleOutput;
  end;

  IScale = interface(IInvokable)
  ['{F9C0CC9D-4070-49D7-8047-D5E424B564E7}']
    function Connect: IScale;
    function Disconnect: IScale;
    function Request: IScale;
  end;

implementation

end.
