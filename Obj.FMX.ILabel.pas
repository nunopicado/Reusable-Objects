(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : ILabel                                                   **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(** Classes       : TILabel, implements I<TLabel>                            **)
(******************************************************************************)
(** Dependencies  : Obj.SSI.GenericIntf                                      **)
(**               : FMX                                                      **)
(******************************************************************************)
(** Description   : An interfaced version of FMX.TLabel, allowing more       **)
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
(**                 terms                                                    **)
(******************************************************************************)

unit Obj.FMX.ILabel;

interface

uses
    Obj.SSI.GenericIntf, FMX.Types, FMX.StdCtrls;

type
    TILabel = Class(TLabel, I<TLabel>)
    public
      class function New(Parent: TFMXObject; Caption: String; Left, Top: Integer): I<TLabel>;
      function Obj: TLabel;
    End;

implementation

{ TLabel }

class function TILabel.New(Parent: TFMXObject; Caption: String; Left, Top: Integer): I<TLabel>;
begin
     Result                := inherited Create(nil);
     Result.Obj.Parent     := Parent;
     Result.Obj.Position.X := Left;
     Result.Obj.Position.Y := Top;
     Result.Obj.Text       := Caption;
end;

function TILabel.Obj: TLabel;
begin
     Result := Self;
end;

end.

