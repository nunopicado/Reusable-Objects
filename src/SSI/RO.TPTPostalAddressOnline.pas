(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPostalAddress                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    :                                                          **)
(******************************************************************************)
(** Enumerators   :                                                          **)
(******************************************************************************)
(** Classes       : TPTPostalAddressOnline                                   **)
(******************************************************************************)
(** Decorators    :                                                          **)
(******************************************************************************)
(** Extensions    :                                                          **)
(******************************************************************************)
(** Other types   :                                                          **)
(******************************************************************************)
(** Dependencies  : Indy                                                     **)
(******************************************************************************)
(** Description   :                                                          **)
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

unit RO.TPTPostalAddressOnline;

interface

uses
    RO.IPostalCode
  , RO.IPostalAddress
  , RO.IValue
  , RO.IXPath
  , RO.IGeoCoordinate
  , XmlIntf
  ;

type
  TPTPostalAddressOnline = class(TInterfacedObject, IPostalAddress)
  private type
    TCTTAddress = class
    private
      FXML: IValue<IXPath>;
      FValid: IBoolean;
    public
      constructor Create(const XMLData: IString);
      function Address1: string;
      function Address2: string;
      function PostalCode: IPostalCode;
      function City: string;
      function Region: string;
      function Country: string;
    end;
  private var
    FCTTAddress: IValue<TCTTAddress>;
  public
    constructor Create(const PostalCode: IPostalCode);
    destructor Destroy; override;
    class function New(const PostalCode: IPostalCode): IPostalAddress;
    function AsString: string;
    function Address1: string;
    function Address2: string;
    function PostalCode: IPostalCode;
    function City: string;
    function Region: string;
    function Country: string;
    function Latitude: IGeoCoordinate;
    function Longitude: IGeoCoordinate;
  end;

implementation

uses
    RO.TValue
  , RO.TPTPostalCode
  , RO.TXPath
  , RO.TGeoCoordinate
  , RO.TIf
  , RO.TGetHTTP
  , RO.TSafeNodeText
  , SysUtils
  ;

{ TPTPostalAddressOnline }
{$REGION TPTPostalAddressOnline}

function TPTPostalAddressOnline.Address1: string;
begin
  Result := FCTTAddress.Value.Address1;
end;

function TPTPostalAddressOnline.Address2: string;
begin
  Result := FCTTAddress.Value.Address2;
end;

function TPTPostalAddressOnline.AsString: string;
begin
  Result :=
    Address1 + sLineBreak +
    Address2 + sLineBreak +
    PostalCode.AsString + ' ' + City + sLineBreak +
    Region + ' - ' + Country;
end;

function TPTPostalAddressOnline.City: string;
begin
  Result := FCTTAddress.Value.City;
end;

function TPTPostalAddressOnline.Country: string;
begin
  Result := FCTTAddress.Value.Country;
end;

constructor TPTPostalAddressOnline.Create(const PostalCode: IPostalCode);
begin
  FCTTAddress := TValue<TCTTAddress>.New(
    function : TCTTAddress
    begin
      Result := TCTTAddress.Create(
        TGetHTTP.New(
          Format(
            'http://www.ctt.pt/pdcp/xml_pdcp?incodpos=%s',
            [
              TPTCP7.New(PostalCode).AsString
            ]
          )
        )
      );
    end
  );
end;

destructor TPTPostalAddressOnline.Destroy;
begin
  if Assigned(FCTTAddress.Value)
    then FCTTAddress.Value.Free;
  inherited;
end;

function TPTPostalAddressOnline.Latitude: IGeoCoordinate;
begin
  Result := TNullCoordinate.New;
end;

function TPTPostalAddressOnline.Longitude: IGeoCoordinate;
begin
  Result := TNullCoordinate.New;
end;

class function TPTPostalAddressOnline.New(
  const PostalCode: IPostalCode): IPostalAddress;
begin
  Result := Create(PostalCode);
end;

function TPTPostalAddressOnline.PostalCode: IPostalCode;
begin
  Result := FCTTAddress.Value.PostalCode;
end;

function TPTPostalAddressOnline.Region: string;
begin
  Result := FCTTAddress.Value.Region;
end;
{$ENDREGION}

{ TPTPostalAddressOnline.TCTTAddress }
{$REGION TPostalAddressOnline.TCTTAddress}

function TPTPostalAddressOnline.TCTTAddress.Address1: string;
begin
  if FValid.Value
    then
      Result := TSafeNodeText.New(
        FXML.Value.SelectNode('/OK/Localidade/Arruamentos/Rua/Designacao'),
        ''
      ).Value
    else
      Result := '';
end;

function TPTPostalAddressOnline.TCTTAddress.Address2: string;
begin
  if FValid.Value
    then
      Result := TSafeNodeText.New(
        FXML.Value.SelectNode('/OK/Localidade/Arruamentos/Rua/Freguesia'),
        ''
      ).Value
    else
      Result := '';
end;

function TPTPostalAddressOnline.TCTTAddress.City: string;
begin
  if FValid.Value
    then
      Result := TSafeNodeText.New(
        FXML.Value.SelectNode('/OK/Localidade/Designacao'),
        ''
      ).Value
    else
      Result := '';
end;

function TPTPostalAddressOnline.TCTTAddress.Country: string;
begin
  Result := TIf<string>.New(
    FValid.Value,
    'Portugal',
    ''
  ).Eval;
end;

constructor TPTPostalAddressOnline.TCTTAddress.Create(const XMLData: IString);
begin
  FXML := TValue<IXPath>.New(
    function : IXPath
    begin
      Result := TXPath.New(
        XMLData.Value
      );
    end
  );

  FValid := TBoolean.New(
    function : Boolean
    begin
      Result := Assigned(
        FXML.Value
          .SelectNode('/OK')
      );
    end
  );
end;

function TPTPostalAddressOnline.TCTTAddress.PostalCode: IPostalCode;
begin
  if FValid.Value
    then Result := TPTPostalCode.New(
      Format(
        '%s-%s',
        [
          TSafeNodeText.New(
            FXML.Value.SelectNode('/OK/Localidade/Arruamentos/Rua/CodPos/CP4'),
            ''
          ).Value,
          TSafeNodeText.New(
            FXML.Value.SelectNode('/OK/Localidade/Arruamentos/Rua/CodPos/CP3'),
            ''
          ).Value
        ]
      )
    )
    else Result := TNullPostalCode.New;
end;

function TPTPostalAddressOnline.TCTTAddress.Region: string;
begin
  if FValid.Value
    then
      Result := TSafeNodeText.New(
        FXML.Value.SelectNode('/OK/Localidade/Distrito'),
        ''
      ).Value
    else
      Result := '';
end;
{$ENDREGION}

end.
