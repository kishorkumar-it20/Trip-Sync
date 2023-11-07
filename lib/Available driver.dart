import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Driver {
  final String name;
  final String imageUrl;
  bool isAvailable;

  Driver({
    required this.name,
    required this.imageUrl,
    this.isAvailable = false,
  });
}

class AvailableDrivers extends StatefulWidget {
  const AvailableDrivers({Key? key}) : super(key: key);

  @override
  State<AvailableDrivers> createState() => _AvailableDriversState();
}

class _AvailableDriversState extends State<AvailableDrivers> {
  // Create a list of drivers
  List<Driver> drivers = [
    Driver(name: "Daniel", imageUrl: "assets/profile/story 6.jpg", isAvailable: true),
    Driver(name: "James", imageUrl: "assets/profile/story 4.jpg", isAvailable: false),
    Driver(name: "Noah", imageUrl: "assets/profile/story 5.jpg", isAvailable: true),
    Driver(name: "Leo", imageUrl: "assets/profile/profile11.jpg", isAvailable: true),
    Driver(name: "Sebastian", imageUrl: "assets/profile/profile11.jpg", isAvailable: false),
    Driver(name: "Henry", imageUrl: "assets/profile/profile12.jpg", isAvailable: true),
    Driver(name: "Jacob", imageUrl: "assets/profile/profile13.jpg", isAvailable: false),
  ];

  Driver? selectedDriver;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Of Drivers",
          style: TextStyle(fontSize: 25, letterSpacing: 1),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF27374D),
        toolbarHeight: 100,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            iconSize: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
              maxRadius: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Availability of drivers", style: TextStyle(fontSize: 25, letterSpacing: 2)),
          ),
          // List of drivers
          Expanded(
            child: ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: driver == selectedDriver ? const Color(0xFF27374D) : driver.isAvailable ? Colors.white : const Color(0xFFEEEEEE),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.all(10.0),
                    child: RadioListTile<Driver?>(
                      value: driver,
                      groupValue: selectedDriver,
                      onChanged: driver.isAvailable ? (selected) {
                        // Handle radio button selection for available drivers
                        setState(() {
                          selectedDriver = selected;
                        });
                      } : null,

                      title: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image(
                                image: AssetImage(driver.imageUrl),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(driver.name, style: const TextStyle(fontSize: 20, letterSpacing: 2)),
                              const SizedBox(height: 10),
                              Text(driver.isAvailable?"Available":"UnAvailable",style: TextStyle(fontSize: 15, letterSpacing: 2,color: Colors.grey))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


