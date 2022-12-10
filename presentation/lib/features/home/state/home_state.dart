import 'package:domain/models/account_details_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int bottomIndex,
    @Default(0) int noOfItemsInCart,
    AccountDetails? accountDetails,
  }) = _HomeState;
}
