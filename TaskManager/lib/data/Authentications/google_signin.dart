import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studentconnect/data/databse/database_functions.dart';

class DemoUser implements User {
  @override
  final String uid;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoURL;
  @override
  final bool emailVerified;
  @override
  final bool isAnonymous;

  DemoUser({
    this.uid = 'demo_student_akshat',
    this.email = 'student@connect.edu',
    this.displayName = 'Akshat (Student)',
    this.photoURL = '',
    this.emailVerified = true,
    this.isAnonymous = false,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User? _demoUser;

  static User? get currentUser => _demoUser ?? auth.currentUser;

  static void setDemoUser({
    String name = 'Akshat (Student)',
    String email = 'student@connect.edu',
  }) {
    _demoUser = DemoUser(
      displayName: name,
      email: email,
      uid: 'demo_${email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
    );
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '326434808011-dueuupjk89ebi3ftbu9h4ebpemi4qpsh.apps.googleusercontent.com'
        : null,
  );

  static Future<User?> guestSignIn({
    String name = 'Akshat (Student)',
    String email = 'student@connect.edu',
  }) async {
    setDemoUser(name: name, email: email);
    try {
      await Database.firestore.collection('User').doc(email).set(
        {
          'email': email,
          'photoUrl': '',
          'userName': name,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Firestore sync for demo user: $e');
    }
    return currentUser;
  }

  static Future<UserCredential?> googleSignin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      if (userCredential.user != null && userCredential.user!.email != null) {
        await Database.firestore
            .collection('User')
            .doc(userCredential.user!.email)
            .set(
          {
            'email': userCredential.user!.email,
            'photoUrl': userCredential.user!.photoURL ?? '',
            'userName': userCredential.user!.displayName ?? 'Student',
          },
          SetOptions(merge: true),
        );
      }
      return userCredential;
    } catch (e) {
      print('Google sign in error: $e');
      return null;
    }
  }

  static Future<void> GoogleLogout() async {
    _demoUser = null;
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await auth.signOut();
    } catch (_) {}
  }
}
