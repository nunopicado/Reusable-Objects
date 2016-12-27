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
var
  Valor   : Integer;
  Ch      : Char;
begin
     Result  := Self;
     Valor   := 0;
     for Ch in (FEntidade + FID + FValor) do
         Valor := ((Valor + StrToInt(Ch)) * 10) mod 97;
     Valor      := 98 - ((Valor * 10) mod 97);
     FReference := FID + Valor.ToString.PadLeft(2, '0');
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
