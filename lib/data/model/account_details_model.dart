import 'package:json_annotation/json_annotation.dart';

part 'account_details_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class AccountDetailsModel {
  AccountDetailsModel(this.name, this.phoneNumber, this.addresses);

  factory AccountDetailsModel.fromDocument(json) => _$AccountDetailsModelFromJson(json);
  String name;
  String? phoneNumber;
  @JsonKey(defaultValue: [])
  List<AddressModel> addresses;

  Map<String, dynamic> toJson() => _$AccountDetailsModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AddressModel {
  factory AddressModel.fromJson(json) => _$AddressModelFromJson(json);
  String name;
  String pincode;
  String address;
  String city;
  String state;
  String phoneNumber;
  @JsonKey(defaultValue: false)
  bool isDefault;

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  @override
  String toString() {
    return 'Address{name: $name, pincode: $pincode, address: $address, city: $city, state: $state, phoneNumber: $phoneNumber, isDefault: $isDefault}';
  }

  AddressModel(this.name, this.pincode, this.address, this.city, this.state, this.phoneNumber, this.isDefault);
}
