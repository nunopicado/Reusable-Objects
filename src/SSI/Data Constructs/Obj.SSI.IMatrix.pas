unit Obj.SSI.IMatrix;

interface

type
  IMatrix<T> = Interface
  ['{3769B3FE-376D-4430-9652-48E6BF85A9CA}']
    function Cell(const Col, Row: LongInt): T;
    function Edit(const Col, Row: LongInt; const Value: T): IMatrix<T>;
    function ColCount: Integer;
    function RowCount: Integer;
    function Resize(const ColCount, RowCount: LongInt): IMatrix<T>;
  end;

implementation

end.
