import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/eat_drink_widget.dart';
import './widgets/essentials_widget.dart';
import './widgets/parallax_header_widget.dart';
import './widgets/sticky_tab_bar_widget.dart';
import './widgets/top_sights_widget.dart';
import './widgets/why_go_now_widget.dart';
import './widgets/work_friendly_widget.dart';

class CityGuideDetail extends StatefulWidget {
  const CityGuideDetail({Key? key}) : super(key: key);

  @override
  State<CityGuideDetail> createState() => _CityGuideDetailState();
}

class _CityGuideDetailState extends State<CityGuideDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _isBookmarked = false;
  bool _isLoading = true;

  final List<String> _tabs = [
    'Why Go Now',
    'Essentials',
    'Top Sights',
    'Eat & Drink',
    'Work-Friendly',
  ];

  // Mock data for the city guide
  final Map<String, dynamic> _cityGuideData = {
    'cityName': 'Barcelona',
    'heroImage':
        'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
    'liveStats': {
      'temperature': 24,
      'activeTravelers': 1247,
      'safetyScore': 8.5,
      'wifiQuality': 92,
    },
    'currentEvents': [
      {
        'title': 'La Mercè Festival',
        'description':
            'Barcelona\'s biggest street festival with parades, concerts, and fireworks',
        'icon': 'celebration',
      },
      {
        'title': 'Beach Season Peak',
        'description':
            'Perfect weather for Barceloneta Beach and coastal activities',
        'icon': 'beach_access',
      },
      {
        'title': 'Gaudí Exhibition',
        'description':
            'Special exhibition at Casa Batlló featuring rare architectural pieces',
        'icon': 'museum',
      },
    ],
    'seasonalHighlights': [
      'Perfect Mediterranean climate with 25°C average temperature',
      'Extended daylight hours until 9 PM for more sightseeing time',
      'Peak season for rooftop bars and outdoor dining experiences',
      'Ideal conditions for walking tours through Gothic Quarter',
      'Beach activities and water sports at their best',
    ],
    'rightNow': {
      'description':
          'Barcelona is experiencing its golden hour with perfect weather, vibrant street life, and countless outdoor events. The city\'s energy is at its peak with locals and travelers enjoying the Mediterranean lifestyle.',
      'tip':
          'Book restaurant reservations in advance as outdoor terraces are in high demand during this season.',
    },
    'essentials': {
      'transportation': {
        'overview':
            'Barcelona has an excellent public transportation system including metro, buses, and trams.',
        'tips': [
          'Buy a T-10 card for 10 metro/bus rides at a discounted price',
          'Metro runs from 5 AM to midnight (2 AM on Fridays and Saturdays)',
          'Airport connected by Aerobus and metro Line 9',
          'Bicing bike-sharing system available for short trips',
        ],
        'details': {
          'Metro zones': '1-6 (most attractions in Zone 1)',
          'Single ticket': '€2.40',
          'T-10 card': '€11.35',
          'Airport transfer': '€5.90 (Aerobus)',
        },
        'emergency': 'Emergency transport info: Call 112 for emergencies',
      },
      'currency': {
        'overview':
            'Spain uses the Euro (€). Credit cards widely accepted, but carry cash for small vendors.',
        'tips': [
          'ATMs available throughout the city',
          'Contactless payments accepted in most places',
          'Tipping 5-10% at restaurants is appreciated but not mandatory',
          'Markets and small bars often prefer cash',
        ],
        'details': {
          'Currency': 'Euro (€)',
          'ATM fees': '€2-5 for foreign cards',
          'Credit cards': 'Visa, Mastercard widely accepted',
          'Tipping': '5-10% at restaurants',
        },
      },
      'safety': {
        'overview':
            'Barcelona is generally safe, but be aware of pickpockets in tourist areas.',
        'tips': [
          'Keep valuables in hotel safe',
          'Be extra cautious on Las Ramblas and in metro',
          'Avoid displaying expensive items openly',
          'Stay in well-lit areas at night',
          'Emergency number is 112',
        ],
        'emergency':
            'Emergency services: 112 (general), 091 (police), 080 (fire)',
      },
      'customs': {
        'overview':
            'Catalans are proud of their culture and language. Learning basic Catalan phrases is appreciated.',
        'tips': [
          'Lunch is typically 2-4 PM, dinner after 9 PM',
          'Shops close 2-5 PM for siesta',
          'Greet with two kisses on the cheek',
          'Catalans prefer Catalan over Spanish when possible',
        ],
        'details': {
          'Language': 'Catalan and Spanish',
          'Meal times': 'Lunch 2-4 PM, Dinner 9-11 PM',
          'Siesta': '2-5 PM (many shops closed)',
          'Greeting': 'Two kisses on cheek',
        },
      },
      'language': {
        'overview':
            'Catalan is the official language, but Spanish is widely spoken. English in tourist areas.',
        'tips': [
          'Learn basic Catalan greetings: "Bon dia" (Good morning)',
          'Most menus available in English in tourist areas',
          'Download Google Translate with offline Catalan',
          'Locals appreciate attempts to speak Catalan',
        ],
        'details': {
          'Primary': 'Catalan',
          'Secondary': 'Spanish (Castilian)',
          'Tourist areas': 'English widely spoken',
          'Useful app': 'Google Translate with offline mode',
        },
      },
    },
    'topSights': [
      {
        'name': 'Sagrada Família',
        'description':
            'Gaudí\'s masterpiece basilica, a UNESCO World Heritage site with breathtaking architecture and intricate facades.',
        'image':
            'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.8,
        'category': 'Architecture',
        'duration': '2-3 hours',
        'distance': '0.5 km from city center',
        'price': '€26-33',
      },
      {
        'name': 'Park Güell',
        'description':
            'Whimsical park designed by Gaudí featuring colorful mosaics, unique architecture, and panoramic city views.',
        'image':
            'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.6,
        'category': 'Park',
        'duration': '2-4 hours',
        'distance': '3 km from city center',
        'price': '€10',
      },
      {
        'name': 'Gothic Quarter',
        'description':
            'Medieval neighborhood with narrow streets, historic buildings, and charming squares perfect for wandering.',
        'image':
            'https://images.unsplash.com/photo-1544947950-fa07a98d237f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.7,
        'category': 'Historic',
        'duration': '3-5 hours',
        'distance': 'City center',
        'price': 'Free',
      },
    ],
    'restaurants': [
      {
        'name': 'Cal Pep',
        'description':
            'Legendary tapas bar serving fresh seafood and traditional Catalan dishes in a lively atmosphere.',
        'image':
            'https://images.unsplash.com/photo-1544148103-0773bf10d330?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.5,
        'cuisine': 'Tapas',
        'priceRange': '\$\$\$',
        'address': 'Plaça de les Olles, 8, El Born',
        'hours': '7:30 PM - 1:30 AM (Closed Sun-Mon)',
        'distance': '5 min walk',
        'specialties': [
          'Gambas al ajillo',
          'Jamón ibérico',
          'Pulpo a la gallega'
        ],
      },
      {
        'name': 'Disfrutar',
        'description':
            'Michelin-starred restaurant offering innovative Mediterranean cuisine with creative presentations.',
        'image':
            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.9,
        'cuisine': 'Fine Dining',
        'priceRange': '\$\$\$',
        'address': 'Carrer de Villarroel, 163, Eixample',
        'hours': '1:30 PM - 3:30 PM, 8:30 PM - 11:30 PM',
        'distance': '10 min metro',
        'specialties': [
          'Tasting menu',
          'Molecular gastronomy',
          'Seasonal ingredients'
        ],
      },
      {
        'name': 'La Boquería Market',
        'description':
            'Historic food market with fresh produce, local specialties, and quick bites from various vendors.',
        'image':
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.4,
        'cuisine': 'Market Food',
        'priceRange': '\$',
        'address': 'La Rambla, 91, Ciutat Vella',
        'hours': '8:00 AM - 8:30 PM (Mon-Sat)',
        'distance': '2 min walk',
        'specialties': ['Fresh fruit juices', 'Jamón serrano', 'Local cheeses'],
      },
    ],
    'workSpaces': [
      {
        'name': 'Betahaus Barcelona',
        'description':
            'Modern coworking space in Poble Nou with excellent facilities and a vibrant community of entrepreneurs.',
        'image':
            'https://images.unsplash.com/photo-1497366216548-37526070297c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.6,
        'type': 'Coworking',
        'wifiQuality': 95,
        'noiseLevel': 'Moderate',
        'powerOutlets': 'Abundant',
        'seating': 'Flexible',
        'address': 'Carrer de Pujades, 100, Poble Nou',
        'hours': '24/7 for members',
        'price': '€25/day',
        'amenities': [
          'Meeting rooms',
          'Phone booths',
          'Kitchen',
          'Rooftop terrace'
        ],
      },
      {
        'name': 'Federal Café',
        'description':
            'Australian-style café with reliable WiFi, great coffee, and a laptop-friendly atmosphere.',
        'image':
            'https://images.unsplash.com/photo-1554118811-1e0d58224f24?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.3,
        'type': 'Café',
        'wifiQuality': 85,
        'noiseLevel': 'Quiet',
        'powerOutlets': 'Limited',
        'seating': 'Communal tables',
        'address': 'Carrer del Parlament, 39, Sant Antoni',
        'hours': '8:00 AM - 6:00 PM',
        'price': 'Coffee purchase required',
        'amenities': ['Specialty coffee', 'Healthy food', 'Outdoor seating'],
      },
      {
        'name': 'Biblioteca Arús',
        'description':
            'Historic public library with free WiFi, quiet study areas, and beautiful reading rooms.',
        'image':
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
        'rating': 4.2,
        'type': 'Library',
        'wifiQuality': 78,
        'noiseLevel': 'Quiet',
        'powerOutlets': 'Available',
        'seating': 'Study desks',
        'address': 'Passeig de Sant Joan, 26, Eixample',
        'hours': '9:00 AM - 9:00 PM (Mon-Fri)',
        'price': 'Free',
        'amenities': ['Free WiFi', 'Study rooms', 'Historical architecture'],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _scrollController = ScrollController();
    _loadGuideData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadGuideData() async {
    // Simulate loading delay
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Loading city guide...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            ParallaxHeaderWidget(
              cityName: _cityGuideData['cityName'] as String,
              imageUrl: _cityGuideData['heroImage'] as String,
              isBookmarked: _isBookmarked,
              onBookmarkTap: _toggleBookmark,
              scrollController: _scrollController,
            ),
            StickyTabBarWidget(
              tabController: _tabController,
              tabs: _tabs,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent(
              WhyGoNowWidget(cityData: _cityGuideData),
            ),
            _buildTabContent(
              EssentialsWidget(
                  essentialsData:
                      _cityGuideData['essentials'] as Map<String, dynamic>),
            ),
            _buildTabContent(
              TopSightsWidget(
                  sights: (_cityGuideData['topSights'] as List)
                      .cast<Map<String, dynamic>>()),
            ),
            _buildTabContent(
              EatDrinkWidget(
                  restaurants: (_cityGuideData['restaurants'] as List)
                      .cast<Map<String, dynamic>>()),
            ),
            _buildTabContent(
              WorkFriendlyWidget(
                  workSpaces: (_cityGuideData['workSpaces'] as List)
                      .cast<Map<String, dynamic>>()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _downloadOfflineGuide,
        icon: CustomIconWidget(
          iconName: 'download',
          color: Colors.white,
          size: 20,
        ),
        label: Text('Download Offline'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Widget _buildTabContent(Widget child) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: child,
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? '${_cityGuideData['cityName']} guide saved to bookmarks'
              : '${_cityGuideData['cityName']} guide removed from bookmarks',
        ),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to bookmarks
          },
        ),
      ),
    );
  }

  void _downloadOfflineGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Offline Guide'),
        content: Text(
            'Download ${_cityGuideData['cityName']} guide for offline reading? This will use approximately 15 MB of storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startDownload();
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  void _startDownload() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 5.w,
              height: 5.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3.w),
            Text('Downloading ${_cityGuideData['cityName']} guide...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );

    // Simulate download completion
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${_cityGuideData['cityName']} guide downloaded successfully!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            action: SnackBarAction(
              label: 'View Offline',
              textColor: Colors.white,
              onPressed: () {
                // Navigate to offline guides
              },
            ),
          ),
        );
      }
    });
  }
}
