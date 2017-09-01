(******************************************************************************)
(** Suite         : Reusable Objects                                         **)
(** Object        : IPostalAddress                                           **)
(** Framework     :                                                          **)
(** Developed by  : Nuno Picado                                              **)
(******************************************************************************)
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
    Obj.SSI.IPostalCode
  , Obj.SSI.IPostalAddress
  , Obj.SSI.IGeoCoordinate
  , Obj.SSI.IValue
  ;

type
  TPostalAddress = class(TInterfacedObject, IPostalAddress)
  private
    FAddress1: string;
    FAddress2: string;
    FPostalCode: IPostalCode;
    FCity: string;
    FRegion: string;
    FCountry: string;
    FLatitude: IGeoCoordinate;
    FLongitude: IGeoCoordinate;
  public
    constructor Create(const Address1, Address2: string; const PostalCode: IPostalCode;
                       const City, Region, Country: string; const Latitude,
                       Longitude: IGeoCoordinate); overload;
    class function New(const Address1, Address2: IString; const PostalCode: IPostalCode;
                       const City, Region, Country: IString; const Latitude,
                       Longitude: IGeoCoordinate): IPostalAddress; overload;
    class function New(const Address1, Address2: IString; const PostalCode: IPostalCode;
                       const City, Region, Country: IString): IPostalAddress; overload;
    class function New(const Address1, Address2: string; const PostalCode: IPostalCode;
                       const City, Region, Country: string; const Latitude,
                       Longitude: IGeoCoordinate): IPostalAddress; overload;
    class function New(const Address1, Address2: string; const PostalCode: IPostalCode;
                       const City, Region, Country: string): IPostalAddress; overload;
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
    SysUtils
  , Obj.SSI.TValue
  ;

{ TPostalAddress }

function TPostalAddress.Address1: string;
begin
  Result := FAddress1;
end;

function TPostalAddress.Address2: string;
begin
  Result := FAddress2;
end;

function TPostalAddress.City: string;
begin
  Result := FCity;
end;

function TPostalAddress.Country: string;
begin
  Result := FCountry;
end;

constructor TPostalAddress.Create(const Address1, Address2: string; const PostalCode: IPostalCode;
                                  const City, Region, Country: string; const Latitude, Longitude: IGeoCoordinate);
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

function TPostalAddress.AsString: string;
begin
  Result := FAddress1 + #13#10 +
            FAddress2 + #13#10 +
            FPostalCode.AsString + ' ' + FCity + #13#10 +
            FRegion + ' - ' + FCountry;
end;

class function TPostalAddress.New(const Address1, Address2: IString; const PostalCode: IPostalCode;
                                  const City, Region, Country: IString; const Latitude,
                                  Longitude: IGeoCoordinate): IPostalAddress;
begin
  Result := New(
    Address1.Value,
    Address2.Value,
    PostalCode,
    City.Value,
    Region.Value,
    Country.Value,
    Latitude,
    Longitude
  );
end;

function TPostalAddress.Latitude: IGeoCoordinate;
begin
  Result := FLatitude;
end;

function TPostalAddress.Longitude: IGeoCoordinate;
begin
  Result := FLongitude;
end;

class function TPostalAddress.New(const Address1, Address2: IString; const PostalCode: IPostalCode;
                                  const City, Region, Country: IString): IPostalAddress;
begin
  Result := New(
    Address1.Value,
    Address2.Value,
    PostalCode,
    City.Value,
    Region.Value,
    Country.Value
  );
end;

function TPostalAddress.PostalCode: IPostalCode;
begin
  Result := FPostalCode;
end;

function TPostalAddress.Region: string;
begin
  Result := FRegion;
end;

class function TPostalAddress.New(const Address1, Address2: string; const PostalCode: IPostalCode; const City,
  Region, Country: string; const Latitude, Longitude: IGeoCoordinate): IPostalAddress;
begin
  Result := Create(
    Address1,
    Address2,
    PostalCode,
    City,
    Region,
    Country,
    Latitude,
    Longitude
  );
end;

class function TPostalAddress.New(const Address1, Address2: string; const PostalCode: IPostalCode; const City,
  Region, Country: string): IPostalAddress;
begin
  Result := Create(
    Address1,
    Address2,
    PostalCode,
    City,
    Region,
    Country,
    nil,
    nil
  );
end;

end.
