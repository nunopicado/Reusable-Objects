unit Obj.SSI.IFactory;

interface

type
  TCreationMethod<IBaseClass> = Reference to Function: IBaseClass;

  IFactory<TKey, IBaseClass> = Interface
    function RegClass      (const Key: TKey; const CreationMethod: TCreationMethod<IBaseClass>) : IFactory<TKey, IBaseClass>;
    function UnRegClass    (const Key: TKey) : IFactory<TKey, IBaseClass>;
    function IsRegistered  (const Key: TKey) : Boolean;
    function GetInstance   (const Key: TKey) : TCreationMethod<IBaseClass>;
    function Count                           : Word;
    function InstanceCount (const Key: TKey) : Word;
  End;

implementation

end.
