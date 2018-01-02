(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IStringList                                              **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TStringList                                              **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring4D                                                 **)
(******************************************************************************)
(** Description   : A string list based on Spring Enumerable<T>              **)
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

unit RO.TStringList;

interface

uses
    RO.IStringList
  , Spring.Collections
  , Classes
  ;

type
  TStringList = class(TInterfacedObject, IStringList)
  private
    FList: IList<string>;
  public
    constructor Create(const Item: string);
    class function New(const Item: string): IStringList;
    function Items: IEnumerable<string>;
    function Add(const Item: string): IStringList;
    function Assign(const Strings: TStrings): IStringList;
    function Text: string;
  end;

implementation

{ TStringList }

function TStringList.Add(const Item: string): IStringList;
begin
  Result := Self;
  FList.Add(Item);
end;

function TStringList.Assign(const Strings: TStrings): IStringList;
begin
  Result := Self;
  Strings.Clear;
  FList.ForEach(
    procedure (const Item: string)
    begin
      Strings.Add(Item);
    end
  );
end;

constructor TStringList.Create(const Item: string);
begin
  FList    := TCollections.CreateList<string>;
  Add(Item);
end;

function TStringList.Items: IEnumerable<string>;
begin
  Result := FList;
end;

class function TStringList.New(const Item: string): IStringList;
begin
  Result := Create(Item);
end;

function TStringList.Text: string;
var
  Res: string;
begin
  Res := '';
  FList.ForEach(
    procedure (const Item: string)
    begin
      Res := Res + Item + sLineBreak;
    end
  );
  Result := Res;
end;

end.
