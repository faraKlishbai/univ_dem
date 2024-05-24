import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter AppBar Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> universities = [
    {
      'name': 'Астана медицина университеті',
      'city': 'Нұр-Сұлтан',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/Астана.jpg',
      'programs': 'Medical programs, Nursing programs, etc.',
    },
    {
      'name': 'С.Сейфуллин атындағы Қазақ агротехникалық университеті',
      'city': 'Нұр-Сұлтан',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/С.Суйфуллин.jpg',
      'programs': 'Agricultural Engineering, Agribusiness, etc.',
    },
    {
      'name': 'Ш.Есенов атындағы Каспий мемлекеттік технологиялар және инжиниринг университеті',
      'city': 'Ақтау',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/Ш.Есенов.jpg',
      'programs': 'Engineering, IT, etc.',
    },
    {
      'name': 'М.Оспанов атындағы батыс қазақстан мемлекеттік медицина университеті',
      'city': 'Ақтөбе',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/М.Оспанов.jpg',
      'programs': 'Medical programs, Health Sciences, etc.',
    },
  ];
  List<Map<String, String>> filteredUniversities = [];
  List<String> cities = [];

  @override
  void initState() {
    super.initState();
    filteredUniversities = universities;
    _searchController.addListener(_filterUniversities);
    cities = universities.map((u) => u['city']!).toSet().toList()..sort();
  }

  void _filterUniversities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUniversities = universities
          .where((u) => u['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _filterByCity(String city) {
    setState(() {
      filteredUniversities = universities.where((u) => u['city'] == city).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('City'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: cities.map((city) {
            return ListTile(
              title: Text(city),
              onTap: () {
                _filterByCity(city);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _navigateToDetailScreen(Map<String, String> university) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UniversityDetailScreen(university: university)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('УНИВЕРСИТЕТТЕР ТІЗІМІ', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.clear), onPressed: () => _searchController.clear()),
                IconButton(icon: Icon(Icons.filter_list), onPressed: _showFilterDialog),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUniversities.length,
              itemBuilder: (context, index) {
                final university = filteredUniversities[index];
                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: Image.asset(university['imagePath']!, height: 100, width: 100),
                  title: Text(university['name']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.location_on), SizedBox(width: 8), Text(university['city']!)]),
                      Row(children: [Icon(Icons.phone), SizedBox(width: 8), Text(university['phone']!)]),
                    ],
                  ),
                  onTap: () => _navigateToDetailScreen(university),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UniversityDetailScreen extends StatelessWidget {
  final Map<String, String> university;

  UniversityDetailScreen({required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(university['name']!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(university['imagePath']!, height: 400, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(university['name']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(children: [Icon(Icons.location_on), SizedBox(width: 8), Text(university['city']!)]),
                  SizedBox(height: 16),
                  Row(children: [Icon(Icons.phone), SizedBox(width: 8), Text(university['phone']!)]),
                  SizedBox(height: 16),
                  Text('Programs:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(university['programs']!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}