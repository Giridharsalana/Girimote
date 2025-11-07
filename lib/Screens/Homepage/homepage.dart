import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../Login/login_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final userInfo = FirebaseAuth.instance.currentUser;
  late final userData = FirebaseFirestore.instance.collection("users");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference userDataDoc = userData.doc(userInfo!.uid);
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: userDataDoc.snapshots(),
          initialData: const {
            "Name": "User",
            "Email": "user@example.com",
          },
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var snapShot = snapshot.data as DocumentSnapshot;
              return Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 800 : double.infinity,
                  ),
                  padding: EdgeInsets.all(isDesktop ? 40 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: kPrimaryLightColor,
                                child: Text(
                                  snapShot["Name"]
                                          ?.toString()
                                          .substring(0, 1)
                                          .toUpperCase() ??
                                      "U",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Hi, ${snapShot["Name"]}!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                  color: kPrimaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                snapShot["Email"] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Device Controls",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                _buildControlCard(
                                  context,
                                  title: "Light",
                                  icon: FontAwesomeIcons.lightbulb,
                                  initialIndex: snapShot["Light"] ?? 0,
                                  onToggle: (index) {
                                    userDataDoc.update({'Light': index});
                                  },
                                ),
                                const SizedBox(height: 24),
                                _buildControlCard(
                                  context,
                                  title: "Fan",
                                  icon: FontAwesomeIcons.fan,
                                  initialIndex: snapShot["Fan"] ?? 0,
                                  onToggle: (index) {
                                    userDataDoc.update({'Fan': index});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "😟 Error loading data",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }
            return const Center(
              child: Text(
                "😔 Failed to load",
                style: TextStyle(fontSize: 18),
              ),
            );
          }),
    );
  }

  Widget _buildControlCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required int initialIndex,
    required Function(int?) onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPrimaryLightColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: kPrimaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ToggleSwitch(
            minWidth: 120.0,
            minHeight: 50.0,
            initialLabelIndex: initialIndex,
            cornerRadius: 12.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey[400]!,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            labels: const ['OFF', 'ON'],
            fontSize: 16,
            iconSize: 24.0,
            activeBgColors: const [
              [Colors.red, Colors.redAccent],
              [Colors.green, Colors.lightGreen]
            ],
            animate: true,
            curve: Curves.easeInOut,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}
