(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IString                                                  **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TRichEditText                                            **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  :                                                          **)
(******************************************************************************)
(** Description   : Implements IString, which populates with the text found  **)
(**                 in a database rich text field                            **)
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

unit RO.VCL.TRichEditText;

interface

uses
    DB
  , RO.IValue
  ;

type
  TRichEditText = class(TInterfacedObject, IString)
  private
    FText: IString;
  public
    constructor Create(const DataSet: TDataSet; const FieldName: string);
    class function New(const DataSet: TDataSet; const FieldName: string): IString;
    function Value: string;
    function Refresh: IString;
  end;

implementation

uses
    RO.TValue
  , RO.Using
  , DBCtrls
  , Forms
  ;

{ TRichEditText }

constructor TRichEditText.Create(const DataSet: TDataSet; const FieldName: string);
begin
  FText := TString.New(
    function : string
    var
      Text: string;
    begin
      Using.New<TDataSource>(
        TDataSource.Create(nil),
        procedure (DataSource: TDataSource)
        begin
          DataSource.DataSet := DataSet;
          Using.New<TForm>(
            TForm.Create(nil),
            procedure (Form: TForm)
            begin
              Using.New<TDBRichEdit>(
                TDBRichEdit.Create(nil),
                procedure (RichEdit: TDBRichEdit)
                begin
                  RichEdit.Parent     := Form;
                  RichEdit.DataSource := DataSource;
                  RichEdit.DataField  := FieldName;
                  Text                := RichEdit.Text;
                end
              );
            end
          );
        end
      );
      Result := Text;
    end
  );
end;

class function TRichEditText.New(const DataSet: TDataSet; const FieldName: string): IString;
begin
  Result := Create(DataSet, FieldName);
end;

function TRichEditText.Refresh: IString;
begin
  FText.Refresh;
end;

function TRichEditText.Value: string;
begin
  Result := FText.Value;
end;

end.
