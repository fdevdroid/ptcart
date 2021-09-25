import 'package:fluttercommerce/src/bloc/add_account_details/add_account_details.dart';
import 'package:fluttercommerce/src/bloc/add_address/add_address.dart';
import 'package:fluttercommerce/src/bloc/add_to_cart/add_to_cart_cubit.dart';
import 'package:fluttercommerce/src/bloc/address_card/address_card.dart';
import 'package:fluttercommerce/src/bloc/all_products/all_product_cubit.dart';
import 'package:fluttercommerce/src/bloc/bottom_bar/bottom_bar_cubit.dart';
import 'package:fluttercommerce/src/bloc/cart_item/cart_item.dart';
import 'package:fluttercommerce/src/bloc/cart_status/cart_status_bloc.dart';
import 'package:fluttercommerce/src/bloc/home_page/home_page_cubit.dart';
import 'package:fluttercommerce/src/bloc/my_address/my_address.dart';
import 'package:fluttercommerce/src/bloc/my_orders/my_orders_cubit.dart';
import 'package:fluttercommerce/src/bloc/otp_login/otp_login.dart';
import 'package:fluttercommerce/src/bloc/payment/payment.dart';
import 'package:fluttercommerce/src/bloc/phone_login/phone_login.dart';
import 'package:fluttercommerce/src/bloc/place_order/place_order_cubit.dart';
import 'package:fluttercommerce/src/bloc/product_search/product_search.dart';
import 'package:fluttercommerce/src/bloc/selected_address/account_details_cubit.dart';
import 'package:fluttercommerce/src/repository/auth_repository.dart';
import 'package:fluttercommerce/src/repository/firestore_repository.dart';
import 'package:get_it/get_it.dart';

GetIt _injector = GetIt.I;

class AppInjector {
  factory AppInjector() => _singleton;

  AppInjector._internal();

  static final AppInjector _singleton = AppInjector._internal();

  static T get<T>({String instanceName, dynamic param1, dynamic param2}) =>
      _injector<T>(instanceName: instanceName, param1: param1, param2: param2);

  static const String dealOfTheDay = "deal_of_the_day";
  static const String topProducts = "top_products";
  static const String onSale = "on_sale";

  static void create() {
    _initRepos();
    _initCubits();
    _initNotifiers();
  }

  static void _initRepos() {
    _injector.registerFactory(() => FirestoreRepository());
    _injector.registerFactory(() => AuthRepository());
  }

  static void _initCubits() {
    final firebaseRepo = _injector<FirestoreRepository>();
    final authRepo = _injector<AuthRepository>();

    _injector.registerFactory(() => PhoneLoginCubit());
    _injector.registerFactory(() => OtpLoginCubit(authRepo));

    _injector.registerFactory(() => ProductDataCubit(),
        instanceName: dealOfTheDay);
    _injector.registerFactory(() => ProductDataCubit(),
        instanceName: topProducts);
    _injector.registerFactory(() => ProductDataCubit(), instanceName: onSale);

    _injector.registerFactory(() => AddToCartCubit(firebaseRepo, authRepo));
    _injector
        .registerFactory(() => AddAccountDetailsCubit(firebaseRepo, authRepo));
    _injector.registerFactory(() => ProductSearchCubit(firebaseRepo));
    _injector.registerFactory(() => CartItemCubit(firebaseRepo));
    _injector.registerFactory(() => PaymentCubit());
    _injector.registerFactory(() => PlaceOrderCubit(firebaseRepo));
    _injector.registerFactory(() => AllProductCubit(firebaseRepo));
    _injector.registerFactory(() => MyAddressCubit(firebaseRepo));
    _injector.registerFactory(() => AddAddressCubit(firebaseRepo));
    _injector.registerFactory(() => AddressCardCubit(firebaseRepo));
    _injector.registerFactory(() => MyOrdersCubit(firebaseRepo));
    _injector.registerLazySingleton(() => CartStatusCubit());
    _injector.registerFactory(() => BottomBarCubit());
    _injector.registerLazySingleton(
        () => AccountDetailsCubit(firebaseRepo, authRepo));
  }

  static void _initNotifiers() {}
}
