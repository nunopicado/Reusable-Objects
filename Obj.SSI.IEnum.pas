(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IEnum                                                    **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IEnum                                                    **)
(** Classes       : TEnum, implements IEnum                                  **)
(******************************************************************************)
(** Dependencies  : RTTI                                                     **)
(******************************************************************************)
(** Description   : Allows retrieving an enumerated value to and from any of **)
(**                 its possible representations (EnumeratedValue, String or **)
(**                 Integer                                                  **)
(** Limitations   : Numbered enumerators don't have runtime type information **)
(**                 which is the required for returning an enumerator as a   **)
(**                 string value. This means the AsString method can not be  **)
(**                 used with numbered enumerators                           **)
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

uses
    Generics.Collections
  ;

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

    TNamedEnum<TEnumerator: Record> = Class(TInterfacedObject, IEnum<TEnumerator>)
    private
      FOrigin : IEnum<TEnumerator>;
      FNames  : TList<String>;
      constructor Create(Origin: IEnum<TEnumerator>; Names: Array of String);
      destructor Destroy; Override;
    public
      class function New(Origin: IEnum<TEnumerator>; Names: Array of String): IEnum<TEnumerator>;
      function AsString  : String;
      function AsInteger : Integer;
      function AsEnum    : TEnumerator;
    End;

    TSkipPreffix<TEnumerator: Record> = Class(TInterfacedObject, IEnum<TEnumerator>)
    private
      FOrigin : IEnum<TEnumerator>;
      constructor Create(Origin: IEnum<TEnumerator>);
    public
      class function New(Origin: IEnum<TEnumerator>): IEnum<TEnumerator>;
      function AsString  : String;
      function AsInteger : Integer;
      function AsEnum    : TEnumerator;
    End;

implementation

uses
    TypInfo
  , SysUtils
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

{ TNamedEnum<TEnumerator> }

function TNamedEnum<TEnumerator>.AsEnum: TEnumerator;
begin
     Result := FOrigin.AsEnum;
end;

function TNamedEnum<TEnumerator>.AsInteger: Integer;
begin
     Result := FOrigin.AsInteger;
end;

function TNamedEnum<TEnumerator>.AsString: String;
begin
     Result := FNames[FOrigin.AsInteger];
end;

constructor TNamedEnum<TEnumerator>.Create(Origin: IEnum<TEnumerator>; Names: Array of String);
begin
     FOrigin := Origin;
     FNames  := TList<String>.Create;
     FNames.AddRange(Names);
end;

destructor TNamedEnum<TEnumerator>.Destroy;
begin
     FNames.Free;
     inherited;
end;

class function TNamedEnum<TEnumerator>.New(Origin: IEnum<TEnumerator>; Names: Array of String): IEnum<TEnumerator>;
begin
     Result := Create(Origin, Names);
end;

{ TSkipPreffix<TEnumerator> }

function TSkipPreffix<TEnumerator>.AsEnum: TEnumerator;
begin
     Result := FOrigin.AsEnum;
end;

function TSkipPreffix<TEnumerator>.AsInteger: Integer;
begin
     Result := FOrigin.AsInteger;
end;

function TSkipPreffix<TEnumerator>.AsString: String;
var
   Name: String;
begin
     Name := FOrigin.AsString;
     while CharInSet(Name[1], ['a'..'z']) do
           Delete(Name, 1, 1);
     Result := Name;
end;

constructor TSkipPreffix<TEnumerator>.Create(Origin: IEnum<TEnumerator>);
begin
     FOrigin := Origin;
end;

class function TSkipPreffix<TEnumerator>.New(Origin: IEnum<TEnumerator>): IEnum<TEnumerator>;
begin
     Result := Create(Origin);
end;

end.
