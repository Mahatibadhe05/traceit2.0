import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the currently authenticated Firebase user.
  User? get currentUser => _auth.currentUser;

  // Sign up with email and password.
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Login with email and password.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Logout the currently authenticated user.
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Send password reset email.
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Listen for authentication state changes.
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Get the authenticated user's UID.
  String? get currentUserId {
    return _auth.currentUser?.uid;
  }
}