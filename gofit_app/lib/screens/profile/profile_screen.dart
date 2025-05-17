import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../notifications/notification_settings.dart';
import '../auth/login_screen.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String profileImageUrl = '';
  bool isLoading = true;

  late Box profileBox;

  @override
  void initState() {
    super.initState();
    profileBox = Hive.box('profileBox'); // افتح البوكس
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        final fetchedUsername = doc['username'] ?? 'No Name';
        final fetchedProfileImageUrl = doc['profileImageUrl'] ?? '';

        // حفظ البيانات في Hive
        await profileBox.put('username', fetchedUsername);
        await profileBox.put('email', user.email ?? '');
        await profileBox.put('profileImageUrl', fetchedProfileImageUrl);

        setState(() {
          username = fetchedUsername;
          email = user.email ?? 'No Email';
          profileImageUrl = fetchedProfileImageUrl;
          isLoading = false;
        });
      }
    } catch (e) {
      // لو في مشكلة نقرأ من Hive
      _loadProfileFromLocal();
    }
  }

  void _loadProfileFromLocal() {
    setState(() {
      username = profileBox.get('username', defaultValue: 'No Name');
      email = profileBox.get('email', defaultValue: 'No Email');
      profileImageUrl = profileBox.get('profileImageUrl', defaultValue: '');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : AssetImage('assets/user.jpg') as ImageProvider,
                    ),
                    SizedBox(height: 16),
                    Text(
                      username,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(email, style: TextStyle(color: Colors.grey[600])),
                    SizedBox(height: 30),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(),
                          ),
                        ).then((_) => _getUserData());
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notification Settings'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotificationSettings(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.security),
                      title: Text('Privacy & Terms'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('Logout'),
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Confirm Logout'),
                                content: Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (shouldLogout == true) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
