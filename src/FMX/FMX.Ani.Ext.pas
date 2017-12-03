(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Framework     : FMX                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       :                                                          **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    : TFloatAnimation                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : FMX                                                      **)
(******************************************************************************)
(** Description   : An extension to FMX.ANI unit, with extended capabilities **)
(**                 for some of its classes                                  **)
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

unit FMX.Ani.Ext;

interface

uses
    FMX.Ani
  , Classes
  , FMX.Types
  ;

type
  TFloatAnimation = class(FMX.Ani.TFloatAnimation)
  private
    FNowCreated: Boolean;
  public
    constructor Create(const AOwner: TComponent; const AParent: TFMXObject; const PropertyName: string;
                       const StartValue, StopValue: Single; const OnFinish: TNotifyEvent = nil); overload;
  end;

implementation

{ TDynamicFloatAnimation }

constructor TFloatAnimation.Create(const AOwner: TComponent; const AParent: TFMXObject;
 const PropertyName: String; const StartValue, StopValue: Single; const OnFinish: TNotifyEvent);
begin
     inherited Create(AOwner);
     FNowCreated       := True;
     Self.Parent       := AParent;
     Self.PropertyName := PropertyName;
     Self.StartValue   := StartValue;
     Self.StopValue    := StopValue;
     Self.OnFinish     := OnFinish;
     Start;
end;


end.
