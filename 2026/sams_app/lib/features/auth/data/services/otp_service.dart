import 'package:firebase_auth/firebase_auth.dart';

class OTPService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<void> sendOTP(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception('Failed to send OTP: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store verificationId for later use
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }
  
  String? _verificationId;
  
  Future<UserCredential> verifyOTP(String otpCode) async {
    if (_verificationId == null) {
      throw Exception('Verification ID not found. Request OTP first.');
    }
    
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otpCode,
    );
    
    return await _auth.signInWithCredential(credential);
  }
}
