import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/utils/app_logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    log.i('[Auth] Starting Google Sign-In');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        log.w('[Auth] Google Sign-In cancelled by user');
        return null;
      }
      log.d('[Auth] Google user: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      log.d('[Auth] Got Google auth tokens (accessToken: ${googleAuth.accessToken != null}, idToken: ${googleAuth.idToken != null})');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      log.i('[Auth] Sign-in successful: ${userCredential.user?.uid}');
      log.d('[Auth] Display name: ${userCredential.user?.displayName}');
      log.d('[Auth] Email: ${userCredential.user?.email}');
      log.d('[Auth] Is new user: ${userCredential.additionalUserInfo?.isNewUser}');
      return userCredential;
    } catch (e, stackTrace) {
      log.e('[Auth] Sign-in failed: $e');
      log.e('[Auth] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> signOut() async {
    log.i('[Auth] Signing out user: ${_auth.currentUser?.uid}');
    await _googleSignIn.signOut();
    await _auth.signOut();
    log.i('[Auth] Sign-out complete');
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      log.e('[Auth] Cannot delete account — no user signed in');
      throw Exception('No user signed in');
    }
    log.w('[Auth] Deleting account: ${user.uid}');
    await user.delete();
    log.i('[Auth] Account deleted');
  }
}
