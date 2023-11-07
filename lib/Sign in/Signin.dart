import 'package:bithack_tripsync/Mode.dart';
import 'package:bithack_tripsync/Sign%20in/AuthService.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {

  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      backgroundColor: const Color(0xFF27374D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("TRIP-SYNC",style: TextStyle(fontSize: 35,letterSpacing: 2,color: Colors.white)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 70,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 30, // Set the width of the container
              height: 0, // Set the height of the container
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // Set the background color of the box
                borderRadius: BorderRadius.circular(10), // Set the border radius to make it box-shaped
              ),
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Add your onPressed functionality here
                },
                iconSize: 15,
                color: Colors.black, // Set the icon color
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child:  Container(
            width: 300, // Set the width of the container
            height: 380, // Set the height of the container
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), // Set the background color of the box
              borderRadius: BorderRadius.circular(10), // Set the border radius to make it box-shaped
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Colors.transparent, Colors.white],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: const Image(image: AssetImage("assets/image/image 2.png")),
                    ),
                    const Positioned(
                      top: 70,
                      left: 140,
                      child: Image(image: AssetImage("assets/image/Group 10 (1).png")),
                    ),
                    const Positioned(
                      top: 100,
                      left: 120, // Adjust the position as needed
                      child: Image(image: AssetImage("assets/image/Group.jpg")),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const Text("Sign In With",style: TextStyle(fontSize: 20,letterSpacing: 2),),
                const SizedBox(height: 40,),
                SizedBox(
                  width: 250,
                  height: 45, // Adjust the width according to your needs
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      primary: const Color(0xFF27374D),
                      onPrimary: const Color(0xFF27374D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: authService.signInWithGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/icons8-google-48.png", // Replace with your image asset path
                          width: 24, // Adjust the image size as needed
                          height: 24,
                        ),
                        const SizedBox(width: 8), // Add some spacing between the image and text
                        const Text(
                          'Google',
                          style: TextStyle(color: Colors.white, letterSpacing: 2,fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                const Text("Or",style: TextStyle(fontSize: 20,letterSpacing: 2),),
                const SizedBox(height: 15,),
                SizedBox(
                  width: 250,
                  height: 45, // Adjust the width according to your needs
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Mode()));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      primary: const Color(0xFF27374D),
                      onPrimary: const Color(0xFF27374D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/icons8-facebook-48.png", // Replace with your image asset path
                          width: 24, // Adjust the image size as needed
                          height: 24,
                        ),
                        const SizedBox(width: 8), // Add some spacing between the image and text
                        const Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white, letterSpacing: 2,fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

