(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IFactory                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TFactory, implements IFactory                            **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Implements a generic object factory                      **)
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

unit Obj.SSI.TFactory;

interface

uses
    Generics.Collections
  , Obj.SSI.IFactory
  ;

type
  TFactory<TKey, IBaseClass> = class(TInterfacedObject, IFactory<TKey, IBaseClass>)
  strict private
    const
      cAlreadyRegistered = 'Class already registered in the factory.';
      cNotRegistered     = 'Class is not yet registered in the factory.';
    var
      FList    : TDictionary<TKey, TCreationMethod<IBaseClass>>;
      FCounter : TDictionary<TKey, Word>;
    destructor Destroy; override;
  public
    constructor Create; reintroduce;
    class function New                       : IFactory<TKey, IBaseClass>;
    function RegClass      (const Key: TKey; const CreationMethod: TCreationMethod<IBaseClass>) : IFactory<TKey, IBaseClass>;
    function UnRegClass    (const Key: TKey) : IFactory<TKey, IBaseClass>;
    function IsRegistered  (const Key: TKey) : Boolean;
    function GetInstance   (const Key: TKey) : TCreationMethod<IBaseClass>;
    function Count                           : Word;
    function InstanceCount (const Key: TKey) : Word;
  end;

implementation

uses
    SysUtils
  ;

{ TFactory<TKey, IBaseClass> }

function TFactory<TKey, IBaseClass>.Count: Word;
begin
  Result := FList.Count;
end;

constructor TFactory<TKey, IBaseClass>.Create;
begin
  FList    := TDictionary<TKey, TCreationMethod<IBaseClass>>.Create;
  FCounter := TDictionary<TKey, Word>.Create;
end;

destructor TFactory<TKey, IBaseClass>.Destroy;
begin
  FCounter.Free;
  FList.Free;
  inherited;
end;

function TFactory<TKey, IBaseClass>.GetInstance(const Key: TKey): TCreationMethod<IBaseClass>;
begin
  if not IsRegistered(Key)
    then raise Exception.Create(cNotRegistered);
  Result := FList.Items[Key];
  FCounter.Items[Key] := FCounter.Items[Key] + 1;
end;

function TFactory<TKey, IBaseClass>.InstanceCount(const Key: TKey): Word;
begin
  Result := FCounter.Items[Key];
end;

function TFactory<TKey, IBaseClass>.IsRegistered(const Key: TKey): Boolean;
begin
  Result := FList.ContainsKey(Key);
end;

class function TFactory<TKey, IBaseClass>.New: IFactory<TKey, IBaseClass>;
begin
  Result := Create;
end;

function TFactory<TKey, IBaseClass>.RegClass(const Key: TKey; const CreationMethod: TCreationMethod<IBaseClass>): IFactory<TKey, IBaseClass>;
begin
  Result := Self;
  if IsRegistered(Key)
    then raise Exception.Create(cAlreadyRegistered);
  FList.Add(Key, CreationMethod);
  FCounter.Add(Key, 0);
end;

function TFactory<TKey, IBaseClass>.UnRegClass(const Key: TKey): IFactory<TKey, IBaseClass>;
begin
  Result := Self;
  if not IsRegistered(Key)
    then raise Exception.Create(cNotRegistered);
  FList.Remove(Key);
  FCounter.Remove(Key);
end;

end.
