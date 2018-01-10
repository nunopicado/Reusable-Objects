(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Framework     : VCL                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : THPanel                                                  **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    : VCL.TPanel                                               **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : VCL                                                      **)
(******************************************************************************)
(** Description   : A VCL TPanel Helper which adds capability to center the  **)
(**                 panel on its parent area                                 **)
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

unit RO.VCL.Ext.TPanel;

interface

uses
    VCL.ExtCtrls
  ;

type
  THPanel = class Helper for TPanel
  public
    procedure CenterOnParent;
  end;

implementation

{ THPanel }

procedure THPanel.CenterOnParent;
begin
  Left := (Parent.Width  div 2) - (Width div 2);
  Top  := (Parent.Height div 2) - (Height div 2);
end;

end.

