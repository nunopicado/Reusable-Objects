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
(** Description   : Generates a list of integers based on a criteria string: **)
(**                 FirstValue[,SecondValue]..LimitValue                     **)
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
    FCriteria: string;
    function GetEnumerable: IEnumerable<Integer>;
    function Start: Integer;
    function Stop: Integer;
    function Step: Integer;
  public
    constructor Create(const Criteria: string);
    class function New(const Criteria: string): IEnumerable<Integer>;
    property AsEnumerable: IEnumerable<Integer> read GetEnumerable implements IEnumerable<Integer>;
  end;

implementation

uses
    RO.TValue
  , SysUtils
  ;

{ TIntegerList }

constructor TIntegerList.Create(const Criteria: string);
begin
  FCriteria := Criteria;
  FList     := TValue<IList<Integer>>.New(
    function : IList<Integer>
    var
      V: Integer;
    begin
      Result  := TCollections.CreateList<Integer>;
      V       := Start;
      while Result.Count < Stop do
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

class function TIntegerList.New(const Criteria: string): IEnumerable<Integer>;
begin
  Result := Create(Criteria);
end;

function TIntegerList.Start: Integer;
begin
  Result := FCriteria.Split(
    TArray<string>.Create(',', '..')
  )[0]
    .ToInteger;
end;

function TIntegerList.Step: Integer;
begin
  Result := StrToIntDef(
    FCriteria.Split(
      TArray<string>.Create('..')
    )[0]
      .Split(
        TArray<string>.Create(',')
      )[1],
    Succ(Start)
  ) - Start;
end;

function TIntegerList.Stop: Integer;
begin
  Result := FCriteria.Split(
    TArray<string>.Create('..')
  )[1]
    .ToInteger;
end;

end.
