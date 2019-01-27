(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TResource                                                **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Implements IResource allowing to check and extract a     **)
(**                 resource from the current module
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

unit RO.TResource;

interface

uses
    RO.IResource
  , Classes
  ;

type
  TResource = class(TInterfacedObject, IResource)
  private
    FStream: TResourceStream;
    FResourceName: string;
  public
    constructor Create(const ResourceName: string);
    destructor Destroy; override;
    class function New(const ResourceName: string): IResource;
    function Exists: Boolean;
    function Extract(const FileName: string): IResource; overload;
    function Extract(const Stream: TStream): IResource; overload;
  end;

implementation

uses
    RO.TValue
  , RO.TDataStream
  , Types
  ;

{ TResource }

constructor TResource.Create(const ResourceName: string);
begin
  FResourceName := ResourceName;
  if Exists
    then FStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);
end;

function TResource.Extract(const FileName: string): IResource;
begin
  FStream.Position := 0;
  FStream.SaveToFile(FileName);
end;

destructor TResource.Destroy;
begin
  if Assigned(FStream)
    then FStream.Free;
  inherited;
end;

function TResource.Exists: Boolean;
begin
  Result := FindResource(hInstance, PChar(FResourceName), RT_RCDATA) <> 0;
end;

function TResource.Extract(const Stream: TStream): IResource;
begin
  Stream.CopyFrom(FStream, FStream.Size);
end;

class function TResource.New(const ResourceName: string): IResource;
begin
  Result := Create(ResourceName);
end;

end.
