(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IMBReference                                             **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IMBReference                                             **)
(** Classes       : TMbRef, implements IMBReference, lazy validation         **)
(**               :  assumes all inputs in the correct format                **)
(**                 TMBRefFactory, creates an MBRef, returned as IString,    **)
(**                  handling input preparation and validation               **)
(**                 TNumbersOnly, decorates IString to strip all non-numeric **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Generates MB (Portuguese ATM) payment references         **)
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


unit Obj.SSI.MBRef;

interface

uses
    Obj.SSI.IString
  ;

type
    IMBReference = Interface ['{84BEAF25-94AD-4198-BA38-F8E9A9901287}']
      function Generate: IMBReference;
      function AsString: String;
    End;

    TMBRef = Class(TInterfacedObject, IMBReference)
    private
      FEntidade: String;
      FID: String;
      FValor: String;
      FReference: String;
    public
      constructor Create(Entidade, ID, Valor: IString);
      class function New(Entidade, ID, Valor: IString): IMBReference;
      function Generate: IMBReference;
      function AsString: String;
    End;

    TMBRefFactory = Class(TInterfacedObject, IString)
    private
      FProduct: IMBReference;
    public
      constructor Create(Entidade, ID, Valor: IString);
      class function New(Entidade, ID, Valor: IString): IString;
      function AsString: String;
    End;

    TMBRefIfThen = Class(TInterfacedObject, IString)
    private
      FID: String;
    public
      constructor Create(SubEnt, ID: String);
      class function New(SubEnt, ID: String): IString;
      function AsString: String;
    End;


implementation

uses
    SysUtils
  ;

{ TMBRef }

constructor TMBRef.Create(Entidade, ID, Valor: IString);
begin
     FEntidade := Entidade.AsString;
     FID       := ID.AsString;
     FValor    := Valor.AsString;
end;

function TMBRef.Generate: IMBReference;
  function CalcCheckDigits: String;
  const
       Multiplier: Array [1..20] of Integer = (51, 73, 17, 89, 38, 62, 45, 53, 15, 50,
                                                5, 49, 34, 81, 76, 27, 90,  9, 30,  3);
  var
     i: Integer;
     Valor: Integer;
     Tmp: String;
  begin
       Tmp   := Format('%s%s%s', [FEntidade, FID, FValor]);
       Valor := 0;
       for i := 1 to Tmp.Length do
           Inc(Valor, Multiplier[i] * StrToInt(Tmp[i]));
       Valor := 98 - (Valor mod 97);
       Result := Valor.ToString.PadLeft(2, '0');
  end;
begin
     Result     := Self;
     FReference := Format('%s%s', [FID, CalcCheckDigits]);
end;

class function TMBRef.New(Entidade, ID, Valor: IString): IMBReference;
begin
     Result := Create(Entidade, ID, Valor);
end;

function TMBRef.AsString: String;
begin
     if FReference.IsEmpty
        then Generate;
     Result := FReference;
end;

{ TMBRefFactory }

function TMBRefFactory.AsString: String;
begin
     Result := FProduct.AsString;
end;

constructor TMBRefFactory.Create(Entidade, ID, Valor: IString);
begin
     FProduct := TMBRef.New(
                            TPadded.New(TNumbersOnly.New(Entidade), 5),
                            TPadded.New(TNumbersOnly.New(ID), 7),
                            TPadded.New(TNumbersOnly.New(Valor), 8)
                           )
                       .Generate;
end;

class function TMBRefFactory.New(Entidade, ID, Valor: IString): IString;
begin
     Result := Create(Entidade, ID, Valor);
end;

{ TMBRefIfThen }

function TMBRefIfThen.AsString: String;
begin
     Result := FID;
end;

constructor TMBRefIfThen.Create(SubEnt, ID: String);
begin
     FID := Format('%s%s', [
                            TPadded.New(TNumbersOnly.New(TString.New(SubEnt)), 3).AsString,
                            TPadded.New(TNumbersOnly.New(TString.New(ID)), 4).AsString
                           ]
                  );
end;

class function TMBRefIfThen.New(SubEnt, ID: String): IString;
begin
     Result := Create(SubEnt, ID);
end;

end.
