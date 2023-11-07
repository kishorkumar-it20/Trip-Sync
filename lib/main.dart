import 'package:bithack_tripsync/Sign%20in/Signin.dart';
import 'package:bithack_tripsync/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    home: FirstPage(),
    debugShowCheckedModeBanner: false,
  )
  );
}
class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF27374D),
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100,),
            const Text("TRIP-SYNC",style: TextStyle(fontSize: 45,letterSpacing: 2,color: Colors.white),),
            const  Padding(padding: EdgeInsets.symmetric(vertical: 50)),
            const Image(image: AssetImage("assets/image/Group 101.jpg")),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            const Row(
              children: [
                SizedBox(width: 167,),
                Column(
                  children: [
                    Image(image: AssetImage("assets/image/Line 4.png")),
                    Image(image: AssetImage("assets/image/Line 5.png")),
                    Image(image: AssetImage("assets/image/Line 6.png")),
                  ],
                ),
                SizedBox(width: 5,),
                Image(image: AssetImage("assets/image/Group.png"))
              ],
            ),
            const Image(image: AssetImage("assets/image/Line 2 (1).png")),
            const SizedBox(height: 100,),
            const Text("Scoops of Joy in",style: TextStyle(fontSize: 30,letterSpacing: 2,color: Colors.white),),
            const SizedBox(height: 10,),
            const Text("Every Ride",style: TextStyle(fontSize: 30,letterSpacing: 2,color: Colors.white),),
            const SizedBox(height: 200,),
            SizedBox(
              width: 300,
              height: 50,// Adjust the width according to your needs
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.black, letterSpacing: 2,fontSize: 20),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

