import 'package:fluttercommerce/features/account/account_module.dart';
import 'package:fluttercommerce/global_module.dart';
import 'package:fluttercommerce/features/cart/checkout_module.dart';
import 'package:fluttercommerce/features/login/login_module.dart';
import 'package:core/core.dart';
import 'package:fluttercommerce/features/order/order_module.dart';
import 'package:fluttercommerce/features/product/product_module.dart';

import 'home/home_module.dart';
import 'init/initial_module.dart';

class ModuleInit {
  ModuleInit._();

  static final _modules = <Module>[
    /// Should call first as App level configuration will be defined
    GlobalModule(),

    HomeModule(),
    InitialModule(),
    AddressModule(),
    CheckoutModule(),
    LoginModule(),
    OrderModule(),
    ProductModule(),
  ];

  static void registerModules() {
    for (final module in _modules) {
      module.registerDependencies();
      module.registerGlobalListeners();
    }
  }

  static void closeModules() {
    for (final module in _modules) {
      module.close();
    }
  }
}
