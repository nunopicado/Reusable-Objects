(******************************************************************************)
(** Suite         : Reusable Objects                                         **)   
(** Object        : IStringList                                              **)
(** Framework     : RTL                                                      **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : I<T> descendant, adds functionality to                   **)
(**                 Obj.SSI.GenericIntf                                      **)
(** Classes       : TIStringList, implements I<TStringList>                  **)
(******************************************************************************)
(** Dependencies  : Obj.SSI.GenericIntf                                      **)
(**               : RTL                                                      **)
(******************************************************************************)
(** Description   : An interfaced version of TStringList, allowing more      **)
(**                 streamlined runtime creation                             **)
(******************************************************************************)
(** Licence       : GNU LGPLv3 (http://www.gnu.org/licenses/lgpl-3.0.html)   **)
(** Contributions : You can create pull request for all your desired         **)
(**                 contributions as long as they comply with the guidelines **)
(**                 you can find in the readme.md file in the main directory **)
(**                 of the Reusable Objects repository                       **)
(** Disclaimer    : The licence agreement applies to the code in this unit   **)
(**                 and not to any of its dependencies, which have their own **)
(**                 licence agreement and to which you must comply in their  **)
(**					terms													 **)
(******************************************************************************)

unit Obj.RTL.IStringList;

interface

uses
    Classes, Obj.SSI.GenericIntf;

type
    I<T> = Interface (Obj.SSI.GenericIntf.I<T>)           ['{D6A7F28C-56D5-4D59-8C58-41489D9A3098}']
      function Add(s: String): I<TStringList>;
      function AddNewLine: I<TStringList>;
    End;

    TIStringList = Class(TInterfacedObject, I<TStringList>)
    private
      FObj: TStringList;
    public
      constructor Create(Text: String); Overload;
      destructor Destroy; Override;
      class function New(Text: String): I<TStringList>;
      function Add(s: String): I<TStringList>;
      function AddNewLine: I<TStringList>;
      function Obj: TStringList;
    End;

implementation

{ TIStringList }

function TIStringList.Add(s: String): I<TStringList>;
begin
     Result := Self;
     FObj.Add(s);
end;

function TIStringList.AddNewLine: I<TStringList>;
begin
     Result := Add('');
end;

constructor TIStringList.Create(Text: String);
begin
     inherited Create;
     FObj      := TStringList.Create;
     FObj.Text := Text;
end;

destructor TIStringList.Destroy;
begin
     FObj.Free;
     inherited;
end;

class function TIStringList.New(Text: String): I<TStringList>;
begin
     Result := Create(Text);
end;

function TIStringList.Obj: TStringList;
begin
     Result := FObj;
end;

end.
