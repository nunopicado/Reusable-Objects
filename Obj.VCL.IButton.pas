(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : IButton                                                  **)
(** Framework     : VCL                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : I<T> descendant, adds functionality to                   **)
(**                 Obj.SSI.GenericIntf.I<T>                                 **)
(** Classes       : TIButton, implements I<TButton>                          **)
(******************************************************************************)
(** Dependencies  : Obj.SSI.GenericIntf                                      **)
(**               : RTL, VCL                                                 **)
(******************************************************************************)
(** Description   : An interfaced version of VCL.TButton, allowing more      **)
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

unit Obj.VCL.IButton;

interface

uses
    Obj.SSI.GenericIntf, Controls, VCL.StdCtrls;

type
    TNotifyReference = Reference to procedure (Sender: TObject);
    
    I<T> = Interface (Obj.SSI.GenericIntf.I<T>) ['{6B665225-2600-4611-A4C5-41B95FE6AA39}']
      function Click(ButtonClick: TNotifyReference): I<TButton>;
    End;
    
    TIButton = Class(TButton, I<TButton>)
    private
      FClick: TNotifyReference;
      procedure ButtonClick(Sender: TObject);
    public
      constructor Create; Overload;
      class function New(Parent: TWinControl; Caption: TCaption; Left, Top: Integer): I<TButton>;
      function Obj: TButton;
      function Click(ButtonClick: TNotifyReference): I<TButton>;
    End;

implementation

{ TLabel }

procedure TIButton.ButtonClick(Sender: TObject);
begin
     if Assigned(FClick)
        then FClick(Sender);
end;

function TIButton.Click(ButtonClick: TNotifyReference): I<TButton>;
begin
     FClick := ButtonClick;
     Result := Self;
end;

constructor TIButton.Create;
begin
     inherited Create(nil);
     Self.OnClick := ButtonClick;
end;

class function TIButton.New(Parent: TWinControl; Caption: TCaption; Left, Top: Integer): I<TButton>;
begin
     Result             := Create;
     Result.Obj.Parent  := Parent;
     Result.Obj.Caption := Caption;
     Result.Obj.Left    := Left;
     Result.Obj.Top     := Top;
end;

function TIButton.Obj: TButton;
begin
     Result := Self;
end;

end.