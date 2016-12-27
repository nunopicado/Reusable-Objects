(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IStack                                                   **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IStack                                                   **)
(** Classes       : TStack, implements IStack                                **)
(**                 TSimpleStack, implements IStack based on IList           **)
(******************************************************************************)
(** Dependencies  : IIF                                                      **)
(******************************************************************************)
(** Description   : Handles immutable strings with optional decorations      **)
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

unit Obj.SSI.IStack;

interface

uses
    Obj.SSI.IGenericList
  ;

type
    IStack<T> = Interface ['{CCA75540-59EA-4D01-9E81-63A7926CE242}']
      function Peek           : T;
      function Pop            : IStack<T>;
      function Push(Value: T) : IStack<T>;
      function Count          : Integer;
      function Empty          : Boolean;
    End;

    TStackType = (stLIFO, stFIFO);
    TListFactoryWithValue<T> = Reference to Function (Value: T): IList<T>;
    TListFactoryWithClone<T> = Reference to Function (List: IList<T>; Start, Range: Integer): IList<T>;
    TStack<T> = Class(TInterfacedObject, IStack<T>)
    strict private
      FList      : IList<T>;
      FStackType : TStackType;
      FIdx       : Integer;
      FListFactoryWithValue : TListFactoryWithValue<T>;
      FListFactoryWithClone : TListFactoryWithClone<T>;
      constructor Create(
                         StackType: TStackType;
                         List: IList<T>;
                         ListFactoryWithValue: TListFactoryWithValue<T>;
                         ListFactoryWithClone: TListFactoryWithClone<T>
                        );
      class function New(
                         StackType: TStackType;
                         List: IList<T>;
                         ListFactoryWithValue: TListFactoryWithValue<T>;
                         ListFactoryWithClone: TListFactoryWithClone<T>
                        ): IStack<T>; Overload;
    public
      class function New(
                         StackType: TStackType;
                         Value: T;
                         ListFactoryWithValue: TListFactoryWithValue<T>;
                         ListFactoryWithClone: TListFactoryWithClone<T>
                        ): IStack<T>; Overload;
      function Peek           : T;
      function Pop            : IStack<T>;
      function Push(Value: T) : IStack<T>;
      function Count          : Integer;
      function Empty          : Boolean;
    End;

    TSimpleStack<T> = Class(TInterfacedObject, IStack<T>)
    private
      FOrigin: IStack<T>;
      constructor Create(StackType: TStackType; Value: T);
    public
      class function New(StackType: TStackType; Value: T): IStack<T>;
      function Peek           : T;
      function Pop            : IStack<T>;
      function Push(Value: T) : IStack<T>;
      function Count          : Integer;
      function Empty          : Boolean;
    End;


implementation

uses
    Obj.SSI.IIF
  ;

{ TStack<T> }

function TStack<T>.Count: Integer;
begin
     Result := FList.Count;
end;

constructor TStack<T>.Create(
                             StackType: TStackType;
                             List: IList<T>;
                             ListFactoryWithValue: TListFactoryWithValue<T>;
                             ListFactoryWithClone: TListFactoryWithClone<T>
                            );
begin
     FStackType            := StackType;
     FList                 := List;
     FListFactoryWithValue := ListFactoryWithValue;
     FListFactoryWithClone := ListFactoryWithClone;
     FIdx                  := TIF<Integer>.New(FStackType=stFIFO, FList.Low, FList.High).Eval;
end;

function TStack<T>.Empty: Boolean;
begin
     Result := Count = 0;
end;

class function TStack<T>.New(
                             StackType: TStackType;
                             List: IList<T>;
                             ListFactoryWithValue: TListFactoryWithValue<T>;
                             ListFactoryWithClone: TListFactoryWithClone<T>
                            ): IStack<T>;
begin
     Result := Create(StackType, List, ListFactoryWithValue, ListFactoryWithClone);
end;

class function TStack<T>.New(
                             StackType: TStackType;
                             Value: T;
                             ListFactoryWithValue: TListFactoryWithValue<T>;
                             ListFactoryWithClone: TListFactoryWithClone<T>
                            ): IStack<T>;
begin
     Result := Create(
                      StackType,
                      ListFactoryWithValue(Value),
                      ListFactoryWithValue,
                      ListFactoryWithClone
                     );
end;

function TStack<T>.Peek: T;
begin
     Result := FList.Items[FIdx];
end;

function TStack<T>.Pop: IStack<T>;
begin
     Result := New(
                   FStackType,
                   FListFactoryWithClone(
                                         FList,
                                         TIF<Integer>.New(FStackType=stFIFO, Succ(FList.Low), FList.Low).Eval,
                                         Pred(FList.Count)
                                        ),
                   FListFactoryWithValue,
                   FListFactoryWithClone
                  );
end;

function TStack<T>.Push(Value: T): IStack<T>;
begin
     Result := New(
                   FStackType,
                   FListFactoryWithClone(
                                         FList,
                                         FList.Low,
                                         FList.Count
                                        )
                                    .Add(Value),
                   FListFactoryWithValue,
                   FListFactoryWithClone
                  );
end;


{ TSimpleStack<T> }

function TSimpleStack<T>.Count: Integer;
begin
     Result := FOrigin.Count;
end;

constructor TSimpleStack<T>.Create(StackType: TStackType; Value: T);
begin
     FOrigin := TStack<T>.New(
                              StackType,
                              Value,
                              Function (Value: T): IList<T>
                              begin
                                   Result := TList<T>.New(Value);
                              end,
                              Function (List: IList<T>; Start, Range: Integer): IList<T>
                              begin
                                   Result := TList<T>.New(
                                                          List,
                                                          Start,
                                                          Range
                                                         );
                              end
                             );
end;

function TSimpleStack<T>.Empty: Boolean;
begin
     Result := FOrigin.Empty;
end;

class function TSimpleStack<T>.New(StackType: TStackType; Value: T): IStack<T>;
begin
     Result := Create(StackType, Value);
end;

function TSimpleStack<T>.Peek: T;
begin
     Result := FOrigin.Peek;
end;

function TSimpleStack<T>.Pop: IStack<T>;
begin
     Result := FOrigin.Pop;
end;

function TSimpleStack<T>.Push(Value: T): IStack<T>;
begin
     Result := FOrigin.Push(Value);
end;

end.
