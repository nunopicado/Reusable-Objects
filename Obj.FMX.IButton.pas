(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : IButton                                                  **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : I<T> descendant, adds functionality to                   **)
(**                 Obj.SSI.GenericIntf                                      **)
(** Classes       : TIButton, implements I<TButton>                          **)
(******************************************************************************)
(** Dependencies  : Obj.SSI.GenericIntf                                      **)
(**               : FMX                                                      **)
(******************************************************************************)
(** Description   : An interfaced version of FMX.TButton, allowing more      **)
(**                 streamlined runtime creation                             **)
(******************************************************************************)
(** Instantiating : New(Parent  : TFMXObject (Parent form to place the       **)
(**                                           button)                        **)
(**                     Caption : String     (Button label)                  **)
(**                     Left    : Integer    (Horizontal position on the     **) 
(**                                           parent form                    **)
(**                     Top     : Integer    (Vertical position on the       **) 
(**                                           parent form                    **)
(** Example       : TIButton.New(Self, 'Click Me', 20, 10);                  **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(******************************************************************************)

unit Obj.FMX.IButton;

interface

uses
    Obj.SSI.GenericIntf, FMX.Types, FMX.StdCtrls;

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
      class function New(Parent: TFMXObject; Caption: String; Left, Top: Integer): I<TButton>;
      function Obj: TButton;
      function Click(ButtonClick: TNotifyReference): I<TButton>;
    End;

implementation

{ TLabel }

procedure TIButton.ButtonClick(Sender: TObject);
begin
     FClick(Sender);
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

class function TIButton.New(Parent: TFMXObject; Caption: String; Left, Top: Integer): I<TButton>;
begin
     Result                := Create;
     Result.Obj.Parent     := Parent;
     Result.Obj.Text       := Caption;
     Result.Obj.Position.X := Left;
     Result.Obj.Position.Y := Top;
end;

function TIButton.Obj: TButton;
begin
     Result := Self;
end;

end.