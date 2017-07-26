(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPostalAddress                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
(** Interfaces    : IPostalAddress                                           **)
(** Classes       : TPostalAddress, implements IPostalAddress                **)
(******************************************************************************)
(** Dependencies  : RTL                                                      **)
(******************************************************************************)
(** Description   : Handles postal address values                            **)
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

unit Obj.SSI.TPostalAddress;

interface

uses
    Obj.SSI.IPTPostalCode
  , Obj.SSI.IPostalAddress
  , Obj.SSI.IGeoCoordinate
  , Obj.SSI.IValue
  ;

type
  TPostalAddress = class(TInterfacedObject, IPostalAddress)
  private
    FAddress1: IString;
    FAddress2: IString;
    FPostalCode: IPTPostalCode;
    FCity: IString;
    FRegion: IString;
    FCountry: IString;
    FLatitude: IGeoCoordinate;
    FLongitude: IGeoCoordinate;
  public
    constructor Create(const Address1, Address2: IString; const PostalCode: IPTPostalCode;
                       const City, Region, Country: IString; const Latitude,
                       Longitude: IGeoCoordinate); overload;
    class function New(const Address1, Address2: IString; const PostalCode: IPTPostalCode;
                       const City, Region, Country: IString; const Latitude,
                       Longitude: IGeoCoordinate): IPostalAddress; overload;
    class function New(const Address1, Address2: IString; const PostalCode: IPTPostalCode;
                       const City, Region, Country: IString): IPostalAddress; overload;
    function ToIString: IString;
    function Address1: IString;
    function Address2: IString;
    function PostalCode: IPTPostalCode;
    function City: IString;
    function Region: IString;
    function Country: IString;
    function Latitude: IGeoCoordinate;
    function Longitude: IGeoCoordinate;
  end;

implementation

uses
    SysUtils
  , Obj.SSI.TPrimitive
  ;

{ TPostalAddress }

function TPostalAddress.Address1: IString;
begin
  Result := FAddress1;
end;

function TPostalAddress.Address2: IString;
begin
  Result := FAddress2;
end;

function TPostalAddress.City: IString;
begin
  Result := FCity;
end;

function TPostalAddress.Country: IString;
begin
  Result := FCountry;
end;

constructor TPostalAddress.Create(const Address1, Address2: IString; const PostalCode: IPTPostalCode;
                                  const City, Region, Country: IString; const Latitude, Longitude: IGeoCoordinate);
begin
  inherited Create;
  FAddress1   := Address1;
  FAddress2   := Address2;
  FPostalCode := PostalCode;
  FCity       := City;
  FRegion     := Region;
  FCountry    := Country;
  FLatitude   := Latitude;
  FLongitude  := Longitude;
end;

function TPostalAddress.ToIString: IString;
begin
  Result := TString.New(
    FAddress1.Value + #13#10 +
    FAddress2.Value + #13#10 +
    FPostalCode.ToIString.Value + ' ' + FCity.Value + #13#10 +
    FRegion.Value + ' - ' + FCountry.Value
  );
end;

class function TPostalAddress.New(const Address1, Address2: IString; const PostalCode: IPTPostalCode;
                                  const City, Region, Country: IString; const Latitude,
                                  Longitude: IGeoCoordinate): IPostalAddress;
begin
  Result := Create(Address1, Address2, PostalCode, City, Region, Country, Latitude, Longitude);
end;

function TPostalAddress.Latitude: IGeoCoordinate;
begin
  Result := FLatitude;
end;

function TPostalAddress.Longitude: IGeoCoordinate;
begin
  Result := FLongitude;
end;

class function TPostalAddress.New(const Address1, Address2: IString; const PostalCode: IPTPostalCode;
                                  const City, Region, Country: IString): IPostalAddress;
begin
  Result := Create(Address1, Address2, PostalCode, City, Region, Country, nil, nil);
end;

function TPostalAddress.PostalCode: IPTPostalCode;
begin
  Result := FPostalCode;
end;

function TPostalAddress.Region: IString;
begin
  Result := FRegion;
end;

end.
