(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IEdit                                                    **)
(** Framework     : VCL                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(** Classes       : TIEdit, implements I<TEdit>                              **)
(******************************************************************************)
(** Dependencies  : Obj.SSI.GenericIntf                                      **)
(**               : RTL, VCL                                                 **)
(******************************************************************************)
(** Description   : An interfaced version of VCL.TEdit, allowing more        **)
(**                 streamlined runtime creation                             **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**					terms													 **)
(******************************************************************************)

unit Obj.VCL.IEdit;

interface

uses
    Obj.SSI.GenericIntf, Controls, VCL.StdCtrls;

type
    TIEdit = Class(TEdit, I<TEdit>)
    public
      class function New(Parent: TWinControl; Left, Top: Integer): I<TEdit>;
      function Obj: TEdit;
    End;

implementation

{ TLabel }

class function TIEdit.New(Parent: TWinControl; Left, Top: Integer): I<TEdit>;
begin
     Result            := inherited Create(nil);
     Result.Obj.Parent := Parent;
     Result.Obj.Left   := Left;
     Result.Obj.Top    := Top;
end;

function TIEdit.Obj: TEdit;
begin
     Result := Self;
end;

end.


