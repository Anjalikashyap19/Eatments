// HomeLuxuryPage with persistent bottom navigation bar integration
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
                _buildSectionHeader('Special Offers', 'See all'),
                const SizedBox(height: 16),
                _buildOffersList(),
                const SizedBox(height: 32),
                _buildSectionHeader('Categories', 'Explore'),
                const SizedBox(height: 16),
                _buildLuxuryCategories(),
                const SizedBox(height: 32),
                _buildSectionHeader('Try Something New', 'Suggest me'),
                const SizedBox(height: 16),
                _buildNewExperiences(),
                const SizedBox(height: 32),
                _buildSectionHeader('Your Rewards', 'Redeem'),
                const SizedBox(height: 16),
                _buildRewardsSection(),
                const SizedBox(height: 32),
                _buildFloatingCTA(context),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ],
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

  Widget _buildOffersList() {
    final List<Map<String, String>> offers = [
      {
        'title': 'Weekend Special',
        'description': 'Get 30% off on all orders above ₹2000',
        'code': 'WEEKEND30',
      },
      {
        'title': 'Family Feast',
        'description': 'Free dessert for family bookings (4+ people)',
        'code': 'FAMFEAST',
      },
      {
        'title': 'First Time User',
        'description': '20% off on your first booking with us',
        'code': 'NEW20',
      },
    ];

    return Column(
      children: offers.map((offer) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_offer,
                    color: Colors.orange.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer['title']!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800),
                    ),
                    Text(
                      offer['description']!,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  offer['code']!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLuxuryCategories() {
    final List<Map<String, dynamic>> tags = [
      {'name': 'Romantic', 'icon': Icons.favorite, 'selected': false},
      {'name': 'Celebrations', 'icon': Icons.celebration, 'selected': false},
      {'name': 'Family Style', 'icon': Icons.family_restroom, 'selected': true},
      {'name': 'Private Rooms', 'icon': Icons.meeting_room, 'selected': false},
      {'name': 'Lake View', 'icon': Icons.water, 'selected': false},
      {'name': 'Fine Dining', 'icon': Icons.restaurant, 'selected': false},
      {'name': 'Rooftop', 'icon': Icons.roofing, 'selected': false},
      {'name': 'Live Music', 'icon': Icons.music_note, 'selected': false},
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tags
              .map((tag) => GestureDetector(
            onTap: () {
              setState(() {
                // Toggle selection state
                tag['selected'] = !tag['selected'];
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: tag['selected']
                    ? Colors.orange.shade100
                    : Colors.white,
                border: Border.all(
                  color: tag['selected']
                      ? Colors.orange
                      : Colors.orange.shade200,
                  width: tag['selected'] ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tag['icon'],
                      size: 18,
                      color: tag['selected']
                          ? Colors.orange.shade700
                          : Colors.grey.shade700),
                  const SizedBox(width: 6),
                  Text(
                    tag['name'],
                    style: TextStyle(
                        color: tag['selected']
                            ? Colors.orange.shade800
                            : Colors.grey.shade800,
                        fontWeight: tag['selected']
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ],
              ),
            ),
          ))
              .toList(),
        );
      },
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

  Widget _buildFloatingCTA(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Book A Luxury Table'),
              content: const Text(
                  'An assistant will guide you to your curated experience.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Proceed'),
                )
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          elevation: 5,
          shadowColor: Colors.orange.withOpacity(0.5),
        ),
        icon: const Icon(Icons.restaurant_menu),
        label: const Text(
          'Book Now',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}