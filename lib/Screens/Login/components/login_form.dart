import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Homepage/homepage.dart';
import '../../Signup/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
  }) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Login to your account",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: defaultPadding * 2),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.email),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                )
                    .then((user) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homepage()));
                }).catchError((e) {});
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          // const Text("-- or --"),
          // const Text("Sign in with Google"),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       icon: const Icon(FontAwesomeIcons.google),
          //       onPressed: () async {
          //         await signInWithGoogle();
          //         final user = FirebaseAuth.instance.currentUser;
          //         await FirebaseFirestore.instance
          //             .collection('users')
          //             .doc(user!.uid)
          //             .set({'name': user.displayName, 'email': user.email});
          //         await FirebaseFirestore.instance
          //             .collection('Data')
          //             .doc(user.uid)
          //             .set({}, SetOptions(merge: true));
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const Homepage()));
          //       },
          //     ),
          // const SizedBox(width: defaultPadding),
          // IconButton(
          //   icon: const Icon(FontAwesomeIcons.facebook),
          //   onPressed: () {},
          // ),
          // ],
          // ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
