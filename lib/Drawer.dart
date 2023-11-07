import 'package:bithack_tripsync/Sign%20in/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigatiorDrawer extends StatefulWidget {
  NavigatiorDrawer({Key? key}) : super(key: key);

  @override
  State<NavigatiorDrawer> createState() => _NavigatiorDrawerState();
}

class _NavigatiorDrawerState extends State<NavigatiorDrawer> {
  final user = FirebaseAuth.instance.currentUser!;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) =>  Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text( FirebaseAuth.instance.currentUser!.displayName.toString(),style: const TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.w400),),
          accountEmail: Text(FirebaseAuth.instance.currentUser!.email.toString(),style: TextStyle(fontSize: 17,color: Colors.grey),),
          currentAccountPicture: GestureDetector(
              child:  InkWell(
                child:   CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL!),
                  maxRadius: 25,
                ),
                onTap: (){},
              )
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF27374D)
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {},
                  minVerticalPadding: 25,
                ),

                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favorite'),
                  onTap: () {},
                  minVerticalPadding: 25,
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () {},
                  minVerticalPadding: 25,
                ),
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Message'),
                  onTap: () {},
                  minVerticalPadding: 25,
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Setting'),
                  onTap: () {},
                  minVerticalPadding: 25,
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('Continue reading'),
                  onTap: () {},
                  minVerticalPadding: 25,
                ),
                const Divider(
                  color: Colors.black12,
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign out'),
                   onTap:  authService.signOut,
                  minVerticalPadding: 25,
                ),
              ],
            )
        ),
      ],
    ),
  );
}