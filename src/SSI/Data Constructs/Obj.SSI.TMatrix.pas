(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMatrix                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Classes       : TMatrix, implements IMatrix                              **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Generic Bidimensional List of items                      **)
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

unit Obj.SSI.TMatrix;

interface

uses
    Obj.SSI.IMatrix
  ;

type
  TMatrix<T> = Class(TInterfacedObject, IMatrix<T>)
  private
    FMatrix: Array of Array of T;
  public
    constructor Create(const ColCount, RowCount: Word);
    class function New: IMatrix<T>; Overload;
    class function New(const ColCount, RowCount: Word): IMatrix<T>; Overload;
    function Cell(const Col, Row: LongInt): T;
    function Edit(const Col, Row: LongInt; const Value: T): IMatrix<T>;
    function ColCount: Integer;
    function RowCount: Integer;
    function Resize(const ColCount, RowCount: LongInt): IMatrix<T>;
  End;

implementation

uses
    SysUtils
  ;

{ TStringMatrix }

function TMatrix<T>.Cell(const Col, Row: Integer): T;
begin
  Result := FMatrix[Col][Row];
end;

function TMatrix<T>.ColCount: Integer;
begin
  Result := Length(FMatrix);
end;

constructor TMatrix<T>.Create(const ColCount, RowCount: Word);
var
  i: LongInt;
begin
  SetLength(FMatrix, ColCount);
  for i := Low(FMatrix) to High(FMatrix) do
    SetLength(FMatrix[i], RowCount);
end;

function TMatrix<T>.Edit(const Col, Row: Integer; const Value: T): IMatrix<T>;
begin
  Result            := Self;
  FMatrix[Col][Row] := Value;
end;

class function TMatrix<T>.New: IMatrix<T>;
begin
  Result := Create(1, 1);
end;

class function TMatrix<T>.New(const ColCount, RowCount: Word): IMatrix<T>;
begin
  if (ColCount<1) or (RowCount<1)
    then raise Exception.Create('Cannot have a matrix with no cells.');
  Result := Create(ColCount, RowCount);
end;

function TMatrix<T>.Resize(const ColCount, RowCount: LongInt): IMatrix<T>;
begin
  Result := New(ColCount, RowCount);
end;

function TMatrix<T>.RowCount: Integer;
begin
  Result := Length(FMatrix[0]);
end;

end.
