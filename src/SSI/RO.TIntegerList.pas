(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : Spring.Collections.IList<T>                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TIntegerList                                             **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring4D                                                 **)
(******************************************************************************)
(** Description   : Generates a list of integers                             **)
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

unit RO.TIntegerList;

interface

uses
    Spring.Collections
  , RO.IValue
  ;

type
  TIntegerList = class(TInterfacedObject, IEnumerable<Integer>)
  private
    FList: IValue<IList<Integer>>;
    function GetEnumerable: IEnumerable<Integer>;
  public
    constructor Create(const FirstValue, SecondValue: Integer; const ElementCount: LongWord);
    class function New(const FirstValue, SecondValue: Integer; const ElementCount: LongWord): IEnumerable<Integer>; overload;
    class function New(const FirstValue: Integer; const ElementCount: LongWord): IEnumerable<Integer>; overload;
    property AsEnumerable: IEnumerable<Integer> read GetEnumerable implements IEnumerable<Integer>;
  end;

implementation

uses
    RO.TValue
  ;

{ TIntegerList }

constructor TIntegerList.Create(const FirstValue, SecondValue: Integer; const ElementCount: LongWord);
var
  Step: Integer;
begin
  Step  := SecondValue - FirstValue;
  FList := TValue<IList<Integer>>.New(
    function : IList<Integer>
    var
      V: Integer;
    begin
      Result := TCollections.CreateList<Integer>;
      V      := FirstValue;
      while Result.Count < ElementCount do
        begin
          Result.Add(V);
          Inc(V, Step);
        end
    end
  );
end;

function TIntegerList.GetEnumerable: IEnumerable<Integer>;
begin
  Result := FList.Value;
end;

class function TIntegerList.New(const FirstValue: Integer; const ElementCount: LongWord): IEnumerable<Integer>;
begin
  Result := New(FirstValue, Succ(FirstValue), ElementCount);
end;

class function TIntegerList.New(const FirstValue, SecondValue: Integer; const ElementCount: LongWord): IEnumerable<Integer>;
begin
  Result := Create(FirstValue, SecondValue, ElementCount);
end;

end.
