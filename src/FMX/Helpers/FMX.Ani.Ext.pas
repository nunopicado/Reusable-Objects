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
