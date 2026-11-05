import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const DatingApp());
}

class DatingApp extends StatelessWidget {
  const DatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Dating',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  bool _loading = true;

  List> profiles = [
    {
      'name': 'Pooja',
      'age': 22,
      'distance': '2.4 km away',
      'bio': 'Music & Travel lover 🎧✈️',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
    },
    {
      'name': 'Aman',
      'age': 24,
      'distance': '4.1 km away',
      'bio': 'Gym & Foodie 🏋️‍♂️🍕',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d'
    },
    {
      'name': 'Sneha',
      'age': 21,
      'distance': '1.1 km away',
      'bio': 'Coffee & Books ☕📖',
      'image': 'https://images.unsplash.com/photo-1517841905240-472988babdf9'
    },
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _loading = false);
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _loading = false;
    });
  }

  void _removeTopCard() {
    if (profiles.isNotEmpty) {
      setState(() {
        profiles.removeAt(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Match', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
          : profiles.isEmpty
              ? const Center(child: Text('No more profiles nearby!', style: TextStyle(fontSize: 18)))
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              profiles[0]['image'],
                              height: 380,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${profiles[0]['name']}, ${profiles[0]['age']}',
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.pink, size: 18),
                                        Text(profiles[0]['distance']),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(profiles[0]['bio'], style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FloatingActionButton(
                                      heroTag: 'pass',
                                      backgroundColor: Colors.white,
                                      onPressed: _removeTopCard,
                                      child: const Icon(Icons.close, color: Colors.red, size: 32),
                                    ),
                                    FloatingActionButton(
                                      heroTag: 'like',
                                      backgroundColor: Colors.white,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Liked ${profiles[0]['name']}! ❤️')),
                                        );
                                        _removeTopCard();
                                      },
                                      child: const Icon(Icons.favorite, color: Colors.green, size: 32),
                                    ),
