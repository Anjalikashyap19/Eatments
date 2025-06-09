import 'package:flutter/material.dart';
import 'dart:ui';
import 'bookings_page.dart';
import 'explore_page.dart';
import 'profile_page.dart';
import 'rewards_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';

class HomeLuxuryPage extends StatefulWidget {
  const HomeLuxuryPage({super.key});

  @override
  State<HomeLuxuryPage> createState() => _HomeLuxuryPageState();
}

class _HomeLuxuryPageState extends State<HomeLuxuryPage> {
  int _currentIndex = 0;
  String? _selectedCategory;

  final List<Widget> _pages = const [
    HomeContent(),
    ExplorePageWithSidebar(),
    BookingsPage(),
    RewardsPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.orange[50]?.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.orange),
          onPressed: () => _showLuxuryMenu(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.orange),
            onPressed: () {},
          ),
        ],
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.orange.withOpacity(0.8),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
              BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
              BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Rewards'),
            ],
          ),
        ),
      ),
    );
  }

  void _showLuxuryMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withAlpha((0.6 * 255).round()),
      barrierColor: Colors.black.withAlpha((0.7 * 255).round()),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMenuItem(Icons.person, 'Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            }),
            _buildMenuItem(Icons.settings, 'Settings', () {}),
            _buildMenuItem(Icons.logout, 'Logout', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? _selectedCategory;
  final List<Map<String, dynamic>> categories = [
    {'name': 'North Indian', 'icon': Icons.restaurant_menu},
    {'name': 'Chinese', 'icon': Icons.ramen_dining},
    {'name': 'Italian', 'icon': Icons.local_pizza},
    {'name': 'South Indian', 'icon': Icons.soup_kitchen},
    {'name': 'Desserts', 'icon': Icons.cake},
    {'name': 'Cafe', 'icon': Icons.local_cafe},
    {'name': 'Bar', 'icon': Icons.wine_bar},
    {'name': 'Fast Food', 'icon': Icons.fastfood},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: kToolbarHeight + 24),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.orange.shade100,
                    Colors.orange.shade300,
                  ],
                  stops: const [0.4, 0.2, 0.8, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Eatments',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Curated luxury dining in Bhopal',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _buildSectionHeader('Recommended', 'View all'),
                const SizedBox(height: 16),
                _buildHotelCarousel(),
                const SizedBox(height: 32),
                _buildSectionHeader('All Offers', 'See all'),
                const SizedBox(height: 16),
                _buildAllOffersList(),
                const SizedBox(height: 32),
                _buildSectionHeader('By Experience', 'View all'),
                const SizedBox(height: 16),
                _buildExperienceCategories(),
                const SizedBox(height: 32),
                _buildSectionHeader('Lounge & Bars', 'Explore'),
                const SizedBox(height: 16),
                _buildLoungeCarousel(),
                const SizedBox(height: 32),
                _buildSectionHeader('Resorts & Getaways', 'See all'),
                const SizedBox(height: 16),
                _buildResortsCarousel(),
                const SizedBox(height: 32),
                _buildSectionHeader('Newly Opened', 'Discover'),
                const SizedBox(height: 16),
                _buildNewlyOpenedCarousel(),
                const SizedBox(height: 32),
                _buildSectionHeader('Your Rewards', 'Redeem'),
                const SizedBox(height: 16),
                _buildRewardsSection(),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCategories() {
    final List<Map<String, dynamic>> experiences = [
      {'name': 'Family Friendly', 'icon': Icons.family_restroom, 'color': Colors.blue},
      {'name': 'Couples', 'icon': Icons.favorite, 'color': Colors.pink},
      {'name': 'Ladies Group', 'icon': Icons.people, 'color': Colors.purple},
      {'name': 'Business', 'icon': Icons.business, 'color': Colors.green},
      {'name': 'Solo', 'icon': Icons.person, 'color': Colors.orange},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          final exp = experiences[index];
          return Container(
            width: 120,
            margin: EdgeInsets.only(right: index == experiences.length - 1 ? 0 : 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  exp['color'].withOpacity(0.1),
                  exp['color'].withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: exp['color'].withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: exp['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(exp['icon'], color: exp['color'], size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  exp['name'],
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoungeCarousel() {
    final List<Map<String, dynamic>> lounges = [
      {
        'image': 'assets/lounge1.jpg',
        'title': 'Sky Lounge',
        'subtitle': 'Rooftop cocktails & city views',
        'rating': 4.7,
      },
      {
        'image': 'assets/lounge2.jpg',
        'title': 'The Whiskey Room',
        'subtitle': 'Premium whiskey collection',
        'rating': 4.8,
      },
      {
        'image': 'assets/lounge3.jpg',
        'title': 'Jazz & Wine',
        'subtitle': 'Live music with fine wines',
        'rating': 4.9,
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lounges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = lounges[index];
          return Container(
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(item['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LOUNGE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['subtitle']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange.shade300, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item['rating'].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResortsCarousel() {
    final List<Map<String, dynamic>> resorts = [
      {
        'image': 'assets/resort1.jpg',
        'title': 'Lakeview Retreat',
        'subtitle': 'Luxury by the lake',
        'rating': 4.9,
      },
      {
        'image': 'assets/resort2.jpg',
        'title': 'Hilltop Haven',
        'subtitle': 'Mountain escape',
        'rating': 4.8,
      },
      {
        'image': 'assets/resort3.jpg',
        'title': 'Royal Gardens',
        'subtitle': 'Palatial resort',
        'rating': 5.0,
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: resorts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = resorts[index];
          return Container(
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(item['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'RESORT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['subtitle']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange.shade300, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item['rating'].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewlyOpenedCarousel() {
    final List<Map<String, dynamic>> newPlaces = [
      {
        'image': 'assets/new1.jpg',
        'title': 'The Spice Lab',
        'subtitle': 'Molecular gastronomy',
        'rating': 4.7,
        'tag': 'NEW',
      },
      {
        'image': 'assets/new2.jpg',
        'title': 'Azure',
        'subtitle': 'Mediterranean flavors',
        'rating': 4.8,
        'tag': 'JUST OPENED',
      },
      {
        'image': 'assets/new3.jpg',
        'title': 'Brew & Bites',
        'subtitle': 'Artisanal coffee & snacks',
        'rating': 4.6,
        'tag': 'TRENDING',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: newPlaces.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = newPlaces[index];
          return Container(
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(item['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['tag']!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['subtitle']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange.shade300, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item['rating'].toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildCategoryDropdown() {
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedCategory != null
                    ? Colors.orange.withOpacity(0.8)
                    : Colors.orange.shade200,
                width: _selectedCategory != null ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                value: _selectedCategory,
                hint: const Text('Select cuisine'),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value;
                    HapticFeedback.lightImpact();
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Cuisines'),
                  ),
                  ...categories.map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['name'],
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          key: ValueKey(category['name']),
                          children: [
                            Icon(category['icon'], size: 20, color: Colors.orange),
                            const SizedBox(width: 10),
                            Text(category['name']),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  padding: const EdgeInsets.only(left: 16, right: 8),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  offset: const Offset(0, -10),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
                  iconSize: 24,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildEventTypeDropdown(),
        ),
      ],
    );
  }

  Widget _buildEventTypeDropdown() {
    final List<Map<String, dynamic>> eventTypes = [
      {'name': 'Adventure', 'icon': Icons.terrain},
      {'name': 'Dating', 'icon': Icons.favorite},
      {'name': 'Meeting', 'icon': Icons.people},
      {'name': 'Party', 'icon': Icons.celebration},
      {'name': 'Event', 'icon': Icons.event},
    ];

    String? _selectedEventType;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedEventType != null
              ? Colors.orange.withOpacity(0.8)
              : Colors.orange.shade200,
          width: _selectedEventType != null ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _selectedEventType,
          hint: const Text('Event type'),
          onChanged: (String? value) {
            setState(() {
              _selectedEventType = value;
              HapticFeedback.lightImpact();
            });
          },
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Events'),
            ),
            ...eventTypes.map<DropdownMenuItem<String>>((type) {
              return DropdownMenuItem<String>(
                value: type['name'],
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    key: ValueKey(type['name']),
                    children: [
                      Icon(type['icon'], size: 20, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(type['name']),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.only(left: 16, right: 8),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            offset: const Offset(0, -10),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
            iconSize: 24,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildAllOffersList() {
    final List<Map<String, dynamic>> offers = [
      {
        'title': 'Weekend Special',
        'description': '30% off on all orders above ₹2000',
        'icon': Icons.weekend,
        'color': Colors.purple,
      },
      {
        'title': 'Family Feast',
        'description': 'Free dessert for 4+ people',
        'icon': Icons.family_restroom,
        'color': Colors.green,
      },
      {
        'title': 'First Time User',
        'description': '20% off on first booking',
        'icon': Icons.star,
        'color': Colors.blue,
      },
      {
        'title': 'Happy Hour',
        'description': 'Buy 1 get 1 free on drinks',
        'icon': Icons.local_bar,
        'color': Colors.red,
      },
      {
        'title': 'Lunch Special',
        'description': '15% off on all lunch orders',
        'icon': Icons.lunch_dining,
        'color': Colors.orange,
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 220,
            margin: EdgeInsets.only(right: index == offers.length - 1 ? 0 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  offer['color'].withOpacity(0.1),
                  offer['color'].withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: offer['color'].withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: offer['color'].withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(offer['icon'], color: offer['color']),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    offer['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: offer['color'],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    offer['description'],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'TAP TO APPLY',
                    style: TextStyle(
                      color: offer['color'],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            actionText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const TextField(
          style: TextStyle(color: Colors.black87),
          cursorColor: Colors.orange,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search for experiences...',
            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            prefixIcon: Icon(Icons.search, color: Colors.orange),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelCarousel() {
    final List<Map<String, dynamic>> listings = [
      {
        'image': 'assets/hotel1.jpg',
        'title': 'Twist of Tadka',
        'subtitle': 'Elegant Punjabi Cuisine',
        'rating': 4.8,
        'discount': '20% OFF',
      },
      {
        'image': 'assets/hotel2.jpg',
        'title': 'Spice Garden',
        'subtitle': 'South Indian Ambience',
        'rating': 4.6,
        'discount': '15% OFF',
      },
      {
        'image': 'assets/hotel3.jpg',
        'title': 'Royal Treat',
        'subtitle': 'Dining for Royals',
        'rating': 4.9,
        'discount': '10% OFF',
      },
      {
        'image': 'assets/hotel4.jpg',
        'title': 'Lakeview Bistro',
        'subtitle': 'Scenic Lakeside Dining',
        'rating': 4.7,
        'discount': '25% OFF',
      },
      {
        'image': 'assets/hotel5.jpg',
        'title': 'The Spice Route',
        'subtitle': 'Exotic Asian Flavors',
        'rating': 4.5,
        'discount': '30% OFF',
      },
    ];

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listings.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = listings[index];
          return SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.asset(
                            item['image']!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (item['discount'] != null)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade700,
                                    Colors.red.shade400,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                item['discount']!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange.shade300, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  item['rating'].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle']!,
                  style: TextStyle(color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewExperiences() {
    final List<Map<String, String>> experiences = [
      {
        'image': 'assets/experience1.jpg',
        'title': 'Chef\'s Table',
        'description': 'Exclusive dining with the chef',
      },
      {
        'image': 'assets/experience2.jpg',
        'title': 'Wine Pairing',
        'description': 'Curated wines with each course',
      },
      {
        'image': 'assets/experience3.jpg',
        'title': 'Molecular Gastronomy',
        'description': 'Science meets culinary art',
      },
    ];

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: experiences.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = experiences[index];
          return Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(item['image']!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'NEW EXPERIENCE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['description']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      'Explore',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.shade100,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade700,
                      Colors.red.shade400,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.card_giftcard, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'You have 3 rewards waiting!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white,
              color: Colors.orange,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('600/1000 points',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Gold Tier',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 4,
              shadowColor: Colors.orange.withOpacity(0.4),
            ),
            child: const Text(
              'View Rewards',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}