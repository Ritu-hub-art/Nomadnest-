import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Stream<User?> authState() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.sendEmailVerification();
    await _db.collection('users').doc(cred.user!.uid).set({
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'displayName': null,
      'photoURL': null,
      'city': null,
      'isVerified': false,
      'profileCompleted': false,
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (!(cred.user?.emailVerified ?? false)) {
      throw Exception('EMAIL_NOT_VERIFIED');
    }
  }

  Future<void> resendVerificationEmail() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async => _auth.signOut();

  Future<void> linkAdditionalEmail(String newEmail, String password) async {
    final cred = EmailAuthProvider.credential(
      email: newEmail.trim(),
      password: password,
    );
    await _auth.currentUser!.linkWithCredential(cred);
    await _db.collection('users').doc(_auth.currentUser!.uid).update({
      'emails': FieldValue.arrayUnion([newEmail.trim()])
    });
  }

  Future<void> markVerifiedInProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).update({'isVerified': true});
  }
}
