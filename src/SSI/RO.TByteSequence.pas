(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IByteSequence                                            **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TByteSequence                                            **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Spring                                                   **)
(******************************************************************************)
(** Description   : Creates a list of bytes from a string or decimal sequence**)
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

unit RO.TByteSequence;

interface

uses
    RO.IByteSequence
  , Spring.Collections
  , RO.IValue
  ;

type
  TByteSequence = class(TInterfacedObject, IByteSequence)
  private
    FSequence: IValue<IEnumerable<Byte>>;
  public
    constructor Create(const Sequence: IValue<IEnumerable<Byte>>);
    class function New(const Sequence: IValue<IEnumerable<Byte>>): IByteSequence;
    class function NewFromString(const Sequence: AnsiString): IByteSequence; overload;
    class function NewFromDecimal(const Sequence: string): IByteSequence; overload;
    function AsEnumerable: IEnumerable<Byte>;
  end;

implementation

uses
    RO.TValue
  , SysUtils
  ;

{ TByteSequence }

function TByteSequence.AsEnumerable: IEnumerable<Byte>;
begin
  Result := FSequence.Value;
end;

constructor TByteSequence.Create(const Sequence: IValue<IEnumerable<Byte>>);
begin
  FSequence := Sequence;
end;

class function TByteSequence.New(const Sequence: IValue<IEnumerable<Byte>>): IByteSequence;
begin
  Result := Create(Sequence);
end;

class function TByteSequence.NewFromDecimal(const Sequence: string): IByteSequence;
begin
  Result := New(
    TValue<IEnumerable<Byte>>.New(
      function : IEnumerable<Byte>
      var
        Seq: string;
        List: IList<Byte>;
      begin
        List := TCollections.CreateList<Byte>;
        Seq := Sequence;
        while Seq.Length > 0 do
          begin
            List.Add(StrToInt(Copy(Seq, 1, 3)));
            Delete(Seq, 1, 3);
          end;
        Result := List;
      end
    )
  );
end;

class function TByteSequence.NewFromString(const Sequence: AnsiString): IByteSequence;
begin
  Result := New(
    TValue<IEnumerable<Byte>>.New(
      function : IEnumerable<Byte>
      var
        Buf: array of Byte;
        i: Byte;
      begin
        SetLength(Buf, Length(Sequence));
        for i := 1 to Length(Sequence) do
          Buf[i-1] := Ord(Sequence[i]);
        Result := TCollections.CreateList<Byte>(Buf);
      end
    )
  );
end;

end.
