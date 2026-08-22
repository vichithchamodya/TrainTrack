import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traintrack/models/user_model.dart';
import 'package:traintrack/services/user_service.dart';

class AuthServices {
  // firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // create a user from uid
  UserModel? _userWithFirebaseUserUid(User? user) {
    if (user == null) return null;

    final username = user.displayName?.trim();
    final safeUsername = username != null && username.isNotEmpty
        ? username
        : user.email?.split('@').first ?? '';

    return UserModel(
      uid: user.uid,
      username: safeUsername,
      email: user.email ?? '',
    );
  }

  // create the stream for checking the auth changes in the user
  Stream<UserModel?> get user async* {
    await for (final firebaseUser in _auth.authStateChanges()) {
      if (firebaseUser == null) {
        yield null;
        continue;
      }

      final authUser = _userWithFirebaseUserUid(firebaseUser)!;
      try {
        await for (final profile in _userService.watchUser(
          firebaseUser.uid,
          fallbackName: authUser.username,
          email: authUser.email,
        )) {
          yield profile;
        }
      } catch (e, st) {
        debugPrint("watchUser failed for ${firebaseUser.uid}: $e\n$st");
        yield authUser;
      }
    }
  }

  // signin anonymous
  Future signinAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userWithFirebaseUserUid(user);
    } catch (err) {
      return null;
    }
  }

  // signup using email & password
  Future signupWithEmailAndPassword(
    String email,
    String password, {
    String? username,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      final trimmedUsername = username?.trim();

      if (user != null &&
          trimmedUsername != null &&
          trimmedUsername.isNotEmpty) {
        await user.updateDisplayName(trimmedUsername);
        await user.reload();
        user = _auth.currentUser;
      }

      return _userWithFirebaseUserUid(user);
    } catch (err) {
      return null;
    }
  }

  // signin using email & password
  Future<UserModel> signinWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _userWithFirebaseUserUid(result.user)!;
  }

  // signin using gmail

  // signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      return null;
    }
  }
}
