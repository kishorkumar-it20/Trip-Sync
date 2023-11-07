import 'package:bithack_tripsync/Drawer.dart';
import 'package:bithack_tripsync/Map/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Mode extends StatefulWidget {
  const Mode({Key? key}) : super(key: key);

  @override
  State<Mode> createState() => _ModeState();
}

class _ModeState extends State<Mode> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String selectedVehicle = ''; // Store the selected vehicle mode

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  int selectedGridIndex = -1; // -1 means no grid is selected

  void selectGrid(int index) {
    setState(() {
      selectedGridIndex = index;
      if (index == 0) {
        selectedVehicle = 'Car';
      } else if (index == 1) {
        selectedVehicle = 'Bike';
      } else if (index == 2) {
        selectedVehicle = 'Bus';
      } else if (index == 3) {
        selectedVehicle = 'Rickshaw';
      }
    });
  }

  Color gridBorderColor(int index) {
    return selectedGridIndex == index ? const Color(0xFF27374D) : Colors.grey;
  }

  Color gridColor(int index) {
    return selectedGridIndex == index ? const Color(0xFF27374D) : Colors.transparent;
  }

  Color textColor(int index) {
    return selectedGridIndex == index ? Colors.white : Colors.black;
  }

  Widget buildGridItem(int index, String imageAssetPath, String vehicleName) {
    return InkWell(
      onTap: () => selectGrid(index),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: gridBorderColor(index),
              width: 3,
            ),
            color: gridColor(index),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imageAssetPath),
            ),
          ),
          child: Stack(
            children: [
              if (selectedGridIndex == index)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF27374D),
                    ),
                  ),
                ),
              Positioned(
                bottom: 26, // Adjust the position as needed
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/Line 2 (1).png', // Path to another image asset
                    ),
                    const SizedBox(height: 30),
                    Text(
                      vehicleName,
                      style: TextStyle(
                        color: textColor(index),
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoURL = FirebaseAuth.instance.currentUser!.photoURL.toString();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 400);
    final double itemWidth = size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 230,
            color: const Color(0xFF27374D),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _openDrawer,
                        child: Image.asset(
                          'assets/image/bars-3-bottom-left.png',
                          width: 25,
                          height: 25,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 100),
                      const Text(
                        "TRIP-SYNC",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                      const SizedBox(width: 70),
                       CircleAvatar(
                        backgroundImage: NetworkImage(photoURL),
                        maxRadius: 15,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const SearchBar(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              "Select Your Way of Travel",
              style: TextStyle(fontSize: 25, letterSpacing: 2),
            ),
          ),
          const SizedBox(height: 0),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisSpacing: 2,
                mainAxisSpacing: 1,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                String vehicleName = ''; // Initialize with an empty string
                if (index == 0) {
                  vehicleName = 'Car';
                } else if (index == 1) {
                  vehicleName = 'Bike';
                } else if (index == 2) {
                  vehicleName = 'Bus';
                } else if (index == 3) {
                  vehicleName = 'Rickshaw';
                }
                return buildGridItem(
                  index,
                  'assets/Mode/Group ${index + 1}.png',
                  vehicleName,
                );
              },
            ),
          ),
          if (selectedGridIndex == -1)
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: Row(
                    children: [
                      Icon(Icons.info_outlined, size: 15),
                      SizedBox(width: 2),
                      Text(
                        "Select one to select your pick up point and destination",
                        style: TextStyle(letterSpacing: 0, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                width: 340,
                height: 60, // Adjust the width according to your needs
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(selectedVehicle: selectedVehicle), // Pass the selected vehicle
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    primary: const Color(0xFF27374D),
                    onPrimary: const Color(0xFF27374D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kickoff Route',
                    style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 20),
                  ),
                ),
              ),
            )
        ],
      ),
      drawer: NavigatiorDrawer(),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.search),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
