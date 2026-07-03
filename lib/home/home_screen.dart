import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignIn signIn = GoogleSignIn.instance;

    await signIn.initialize(
      serverClientId:
      "965117279372-krohgttc8ergq0c40n2djv1ccl21fvha.apps.googleusercontent.com",
    );

    final GoogleSignInAccount googleUser = await signIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print(e);
    return null;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final userCredential = await signInWithGoogle();

    setState(() {
      isLoading = false;
    });

    if (userCredential != null) {
      final user = userCredential.user;

      debugPrint("Name : ${user?.displayName}");
      debugPrint("Email : ${user?.email}");
      debugPrint("UID : ${user?.uid}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Welcome ${user?.displayName}")));

      // TODO: Navigate to Home Screen
      // Navigator.pushReplacement(...);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login With Google"),
            ),
          ),
        ),
      ),
    );
  }
}
