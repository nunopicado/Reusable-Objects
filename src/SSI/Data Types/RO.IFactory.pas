(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IFactory                                                 **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IFactory                                                 **)
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

unit RO.IFactory;

interface

type
  TCreationMethod<IBaseClass> = Reference to function: IBaseClass;

  IFactory<TKey, IBaseClass> = interface(IInvokable)
  ['{3EE4C61C-4345-4ED1-94E8-CCB43FC0F9C4}']
    function RegClass      (const Key: TKey; const CreationMethod: TCreationMethod<IBaseClass>) : IFactory<TKey, IBaseClass>;
    function UnRegClass    (const Key: TKey) : IFactory<TKey, IBaseClass>;
    function GetInstance   (const Key: TKey) : TCreationMethod<IBaseClass>;
    function IsRegistered  (const Key: TKey) : Boolean;
    function InstanceCount (const Key: TKey) : Word;
    function Count                           : Word;
  end;

implementation

end.
