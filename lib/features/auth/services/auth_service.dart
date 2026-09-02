import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign Up
  Future<UserCredential> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final userCredential =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName(
      '$firstName $lastName',
    );

    return userCredential;
  }

  // Login
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Forgot Password
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Current User
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
