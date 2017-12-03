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
(** Classes       : TPostalAddressOnline                                     **)
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

unit RO.TPostalAddressOnline;

interface

uses
    RO.IPostalCode
  , RO.IPostalAddress
  , RO.IValue
  , RO.IGeoCoordinate
  ;

type
  TPostalAddressOnline = class(TInterfacedObject, IPostalAddress)
  private
    FPostalAddress: IValue<IPostalAddress>;
  public
    constructor Create(const PostalCode: IPostalCode);
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
  , RO.TPostalAddress
  , RO.TPTPostalCode
  , idHTTP
  , Classes
  , SysUtils
  ;

{ TPostalAddressOnline }

function TPostalAddressOnline.Address1: string;
begin
  Result := FPostalAddress.Value.Address1;
end;

function TPostalAddressOnline.Address2: string;
begin
  Result := FPostalAddress.Value.Address2;
end;

function TPostalAddressOnline.AsString: string;
begin
  Result := FPostalAddress.Value.AsString;
end;

function TPostalAddressOnline.City: string;
begin
  Result := FPostalAddress.Value.City;
end;

function TPostalAddressOnline.Country: string;
begin
  Result := FPostalAddress.Value.Country;
end;

constructor TPostalAddressOnline.Create(const PostalCode: IPostalCode);
begin
  FPostalAddress := TValue<IPostalAddress>.New(
    function : IPostalAddress
    var
      HTTP   : TidHTTP;
      Stream : TMemoryStream;
    begin
      HTTP   := TidHTTP.Create;
      Stream := TMemoryStream.Create;
      try
        HTTP.Get(
          Format(
            'http://www.ctt.pt/pdcp/xml_pdcp?incodpos=%s',
            [
              TPTCP7.New(PostalCode).AsString
            ]
          ),
          Stream
        );

      finally
        HTTP.Free;
        Stream.Free;
      end;



//      Result := TPostalAddress.New(
//      );
    end
  );
end;

function TPostalAddressOnline.Latitude: IGeoCoordinate;
begin
  Result := FPostalAddress.Value.Latitude;
end;

function TPostalAddressOnline.Longitude: IGeoCoordinate;
begin
  Result := FPostalAddress.Value.Longitude;
end;

class function TPostalAddressOnline.New(
  const PostalCode: IPostalCode): IPostalAddress;
begin
  Result := Create(PostalCode);
end;

function TPostalAddressOnline.PostalCode: IPostalCode;
begin
  Result := FPostalAddress.Value.PostalCode;
end;

function TPostalAddressOnline.Region: string;
begin
  Result := FPostalAddress.Value.Region;
end;

end.
