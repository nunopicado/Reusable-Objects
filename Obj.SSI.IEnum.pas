(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IEnum                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IEnum                                                    **)
(** Classes       : TEnum, implements IEnum                                  **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Allows retrieving an enumerated value to and from any of **)
(**                 its possible representations (EnumeratedValue, String or **)
(**                 Integer                                                  **)
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

unit Obj.SSI.IEnum;

interface

type
    IEnum<TEnumerator: Record> = Interface
      function AsString  : String;
      function AsInteger : Integer;
      function AsEnum    : TEnumerator;
    End;

    TEnum<TEnumerator: Record> = Class(TInterfacedObject, IEnum<TEnumerator>)
    private
      FValue: Variant;
      constructor Create(Value: Variant);
    public
      class function New(Value: Variant): IEnum<TEnumerator>;
      function AsString  : String;
      function AsInteger : Integer;
      function AsEnum    : TEnumerator;
    End;

implementation

uses
    TypInfo
  , Variants
  ;

{ TEnum<TEnumerator: Record> }

function TEnum<TEnumerator>.AsEnum: TEnumerator;
var
   V: Integer;
begin
     if VarType(FValue) = varUString
        then V := GetEnumValue(TypeInfo(TEnumerator), FValue)
        else V := FValue;
     Move(V, Result, SizeOf(Result));
end;

function TEnum<TEnumerator>.AsInteger: Integer;
begin
     if VarType(FValue) in [varSmallint, varInteger, varSingle, varDouble, varShortInt, varByte, varWord, varLongWord]
        then Result := FValue
        else Result := GetEnumValue(TypeInfo(TEnumerator), FValue);
end;

function TEnum<TEnumerator>.AsString: String;
begin
     if VarType(FValue) = varUString
        then Result := FValue
        else Result := GetEnumName(TypeInfo(TEnumerator), FValue);
end;

constructor TEnum<TEnumerator>.Create(Value: Variant);
begin
     FValue := Value;
end;

class function TEnum<TEnumerator>.New(Value: Variant): IEnum<TEnumerator>;
begin
     Result := Create(Value);
end;

end.
