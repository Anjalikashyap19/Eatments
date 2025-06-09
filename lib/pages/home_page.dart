// Updated HomeLuxuryPage with offers row and removed Book Now button
import 'package:flutter/material.dart';
import 'dart:ui';
import 'bookings_page.dart';
import 'explore_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'rewards_page.dart';

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
    FavoritesPage(),
    BookingsPage(),
    RewardsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.orange[50],
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.orange,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Rewards'),
        ],
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
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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
                    Colors.orange.shade400,
                    Colors.red.shade400,
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
                        fontSize: 32,
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
                    _buildCategoryFilter(),
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
                _buildSectionHeader('Try Something New', 'Suggest me'),
                const SizedBox(height: 16),
                _buildNewExperiences(),
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
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 200,
            margin: EdgeInsets.only(right: index == offers.length - 1 ? 0 : 16),
            decoration: BoxDecoration(
              color: offer['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: offer['color'].withOpacity(0.3)),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
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

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: EdgeInsets.only(right: index == categories.length - 1 ? 0 : 8),
            child: FilterChip(
              label: Text(category['name']),
              avatar: Icon(category['icon'], size: 20),
              selected: false,
              onSelected: (bool selected) {
                // Handle category selection
              },
              selectedColor: Colors.orange.withOpacity(0.2),
              backgroundColor: Colors.white,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.orange.shade200),
              ),
              labelStyle: TextStyle(
                color: Colors.grey.shade800,
                fontFamily: 'Poppins',
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
        Text(
          actionText,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.orange.shade700,
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
              color: Colors.grey.withOpacity(0.3),
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
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: listings.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = listings[index];
          return SizedBox(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.asset(
                          item['image']!,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                        if (item['discount'] != null)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                borderRadius: BorderRadius.circular(10),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                Text(
                  item['subtitle']!,
                  style: TextStyle(color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange.shade700, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      item['rating'].toString(),
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
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
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: experiences.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = experiences[index];
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
                  Text(
                    'NEW EXPERIENCE',
                    style: TextStyle(
                        color: Colors.orange.shade300,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['description']!,
                    style: const TextStyle(color: Colors.white70),
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
      padding: const EdgeInsets.all(16),
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
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.card_giftcard, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'You have 3 rewards waiting!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.white,
            color: Colors.orange,
            minHeight: 8,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('600/1000 points'),
              Text('Gold Tier'),
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