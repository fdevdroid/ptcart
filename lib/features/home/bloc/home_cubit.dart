import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttercommerce/features/app/firebase/firestore_repository.dart';
import 'package:fluttercommerce/features/app/global_listener/global_listener.dart';
import 'package:fluttercommerce/features/app/state_manager/state_manager.dart';
import 'package:fluttercommerce/features/common/models/account_details_model.dart';
import 'package:fluttercommerce/features/common/models/cart_model.dart';
import 'package:fluttercommerce/features/home/state/home_state.dart';

class HomeScreenCubit extends StateManager<HomeState> {
  HomeScreenCubit(this.firebaseRepo, this.globalListener) : super(const HomeState());

  final FirebaseManager firebaseRepo;
  final GlobalListener globalListener;

  void init() {
    refreshListeners();
  }

  set bottomBarIndex(int value) {
    state = state.copyWith(bottomIndex: value);
  }

  Future<void> refreshListeners() async {
    firebaseRepo.streamUserDetails(firebaseRepo.getUid()).listen((event) {
      _addDetails(event);
    });
    firebaseRepo.cartStatusListen(firebaseRepo.getUid()).listen((event) {
      globalListener.refreshListener(
        GlobalListenerConstants.cartList,
        List<CartModel>.generate(
          event.docs.length,
          (index) {
            final DocumentSnapshot documentSnapshot = event.docs[index];
            return CartModel.fromJson(documentSnapshot.data());
          },
        ),
      );
    });
  }

  void _addDetails(DocumentSnapshot documentSnapshot) {
    final AccountDetails accountDetails = AccountDetails.fromDocument(documentSnapshot.data());
    accountDetails.addresses = accountDetails.addresses.reversed.toList();

    globalListener.refreshListener(
      GlobalListenerConstants.accountDetails,
      accountDetails,
    );

    emit(state.copyWith(
      accountDetails: accountDetails,
    ));
  }
}
