import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:core/src/message_handler/message_handler.dart';
import 'package:navigation/navigation.dart';
import 'package:core/src/state_manager/state_manager.dart';
import 'package:network/network.dart';
import 'package:fluttercommerce/features/login/otp_login/state/otp_login_state.dart';

class OtpLoginViewModel extends StateManager<OtpLoginState> {
  OtpLoginViewModel(this._firebaseManager) : super(const OtpLoginState());
  final FirebaseManager _firebaseManager;

  late String _verificationId;

  void validateButton(String otp) {
    if (otp.length == 6) {
      state = state.copyWith(isButtonEnabled: true);
    } else {
      state = state.copyWith(isButtonEnabled: false);
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    _firebaseManager.sendCode(phoneNumber,
        codeSent: (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      Timer.periodic(const Duration(seconds: 60), (timer) {
        state = state.copyWith(
          codeCountDown:
              "00:${timer.tick < 10 ? "0${timer.tick}" : "${timer.tick}"}",
        );
      });
    }, codeAutoRetrievalTimeout: (String verificationId) {
      _verificationId = verificationId;
      state = state.copyWith(error: '');
    }, verificationFailed: (authException) {
      MessageHandler.showSnackBar(title: authException.message);
      state = state.copyWith(error: authException.message);
      print(authException.message);
    }, verificationCompleted: (AuthCredential auth) {
      state = state.copyWith(otp: '******');

      _login(auth);
    });
  }

  void loginWithOtp(String smsCode, bool isResend) {
    if (state.resendOtpLoading || state.confirmOtpLoading) {
      return;
    }
    state = state.copyWith(
      confirmOtpLoading: !isResend,
      resendOtpLoading: isResend,
    );

    final _credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    _login(_credential);
  }

  Future<void> _login(AuthCredential authCred) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      await firebaseAuth.signInWithCredential(authCred);

      NavigationHandler.navigateTo(
        CheckStatusScreenRoute(checkForAccountStatusOnly: true),
        navigationType: NavigationType.PushAndPopUntil,
        predicate: (route) => false,
      );
    } catch (e) {
      MessageHandler.showSnackBar(title: e.toString());
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(
        confirmOtpLoading: false,
        resendOtpLoading: false,
      );
    }
  }
}
