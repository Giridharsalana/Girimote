import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final db = FirebaseFirestore.instance;

  Future<void> storeUser(String uid, String username, String email) async {
    //Creates the user doc named whatever the user uid is in te collection "users"
    //and adds the user data
    await db
        .collection("users")
        .doc(uid)
        .set({'Name': username, 'Email': email});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Get Started",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Create your account",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: defaultPadding * 2),
          TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (name) {},
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Enter your full name",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
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
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              )
                  .then((user) {
                storeUser(
                    user.user!.uid, nameController.text, emailController.text);
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.user!.uid)
                    .set({'Light': 0, 'Fan': 0}, SetOptions(merge: true));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                // print("error ${error.toString()}");
              });
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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
