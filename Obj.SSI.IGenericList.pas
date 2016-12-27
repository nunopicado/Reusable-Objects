(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IList                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IList                                                    **)
(** Classes       : TList, implements IList                                  **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Generic List of items, based on Generics TList           **)
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

unit Obj.SSI.IGenericList;

interface

uses
    Generics.Collections
  ;

type
    IList<T> = Interface ['{6C5AF484-38DC-42D2-893E-F55B19C4D9CF}']
      function Add(Value: T)                    : IList<T>;
      function Insert(Index: Integer; Value: T) : IList<T>;
      function Delete(Index: Integer)           : IList<T>;
      function Low                              : Integer;
      function High                             : Integer;
      function Count                            : Integer;
      function First                            : T;
      function Last                             : T;
      function GetItem(Index: Integer)          : T;
      property Items[Index: Integer]            : T
          read GetItem;
    End;

    TList<T> = Class(TInterfacedObject, IList<T>)
    strict private
      FList: Generics.Collections.TList<T>;
      constructor Create; Overload;
    public
      destructor Destroy; Override;
      class function New                                                   : IList<T>; Overload;
      class function New(Value: T)                                         : IList<T>; Overload;
      class function New(Source: IList<T>; Start: Integer; Range: Integer) : IList<T>; Overload;
      function Add(Value: T)                                               : IList<T>;
      function Insert(Index: Integer; Value: T)                            : IList<T>;
      function Delete(Index: Integer)                                      : IList<T>;
      function Count                                                       : Integer;
      function Low                                                         : Integer;
      function High                                                        : Integer;
      function First                                                       : T;
      function Last                                                        : T;
      function GetItem(Index: Integer)                                     : T;
      property Items[Index: Integer]                                       : T
          read GetItem;
    End;

implementation

uses
    SysUtils
  ;

{ TList<T> }

function TList<T>.Add(Value: T): IList<T>;
begin
     Result := Self;
     FList.Add(Value);
end;

function TList<T>.Count: Integer;
begin
     Result := FList.Count;
end;

constructor TList<T>.Create;
begin
     FList := Generics.Collections.TList<T>.Create;
end;

function TList<T>.Delete(Index: Integer): IList<T>;
begin
     Result := Self;
     FList.Delete(Index);
end;

destructor TList<T>.Destroy;
begin
     FList.Free;
     inherited;
end;

function TList<T>.First: T;
begin
     Result := FList.First;
end;

function TList<T>.Low: Integer;
begin
     Result := 0;
end;

function TList<T>.GetItem(Index: Integer): T;
begin
     Result := FList.Items[Index];
end;

function TList<T>.Insert(Index: Integer; Value: T): IList<T>;
begin
     Result := Self;
     FList.Insert(Index, Value);
end;

function TList<T>.Last: T;
begin
     Result := FList.Last;
end;

function TList<T>.High: Integer;
begin
     Result := Pred(Count);
end;

class function TList<T>.New(Source: IList<T>; Start: Integer; Range: Integer): IList<T>;
var
   i: Integer;
begin
     if (Start < Source.Low) or (Start + Range - 1 > Source.High)
        then raise Exception.Create('Invalid range for list cloning!');

     if Range = 0
        then Result := New
        else begin
                  Result := New(Source.Items[Start]);
                  with Result do
                       for i := Succ(Start) to Start + Range - 1 do
                           Add(Source.Items[i]);
             end;
end;

class function TList<T>.New: IList<T>;
begin
     Result := Create;
end;

class function TList<T>.New(Value: T): IList<T>;
begin
     Result := New.Add(Value);
end;

end.
