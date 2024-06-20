import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_triple/flutter_triple.dart';

class AuthStore extends Store<UserCredential?> {
  AuthStore() : super(null);

  final _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    setLoading(true);

    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      update(user);
    } on FirebaseAuthException catch (e) {
      setError(e.message ?? e.toString());
    } catch (e) {
      setError(e.toString());
    }

    setLoading(false);
  }

  Future<void> signUp(String email, String password) async {
    setLoading(true);

    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      update(user);
    } on FirebaseAuthException catch (e) {
      setError(e.message ?? e.toString());
    } catch (e) {
      setError(e.toString());
    }

    setLoading(false);
  }

  Future<void> signOut() async {
    setLoading(true);

    await _firebaseAuth.signOut();
    update(null, force: true);

    setLoading(false);
  }
}
