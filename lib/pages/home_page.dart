import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eatments Bhopal',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;
  bool _isMenuOpen = false;
  late AnimationController _menuAnimationController;

  final List<String> _categories = [
    'Only Veg',
    'Family Friendly',
    'Couples',
    'Ladies',
    'Groups',
    'Budget',
    'Luxury'
  ];
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'Twist of Tadka',
      'rating': 4.5,
      'address': 'Narmadapuram road, near Aashima mall',
      'seatsAvailable': true,
      'image': 'assets/restaurant1.jpg',
      'tags': ['Meeting', 'Party', 'Events'],
      'distance': '1.2 km',
      'deliveryTime': '25 min',
      'price': '₹₹',
    },
    {
      'name': 'Spice Garden',
      'rating': 4.2,
      'address': 'MP Nagar, Zone 2',
      'seatsAvailable': false,
      'image': 'assets/restaurant2.jpg',
      'tags': ['Dating', 'Adventures'],
      'distance': '2.5 km',
      'deliveryTime': '35 min',
      'price': '₹₹₹',
    },
    {
      'name': 'Royal Treat',
      'rating': 4.7,
      'address': '10 No. Market',
      'seatsAvailable': true,
      'image': 'assets/restaurant3.jpg',
      'tags': ['Family', 'Celebration'],
      'distance': '3.1 km',
      'deliveryTime': '40 min',
      'price': '₹₹₹₹',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scrollController.addListener(() {
      setState(() {
        _appBarOpacity = (_scrollController.offset / 100).clamp(0.0, 1.0);
      });
    });

    // Start animation after build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _menuAnimationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _menuAnimationController.forward();
      } else {
        _menuAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Hero Image
                    Container(
                      height: 250,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/home.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Content
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildSearchBar(),
                            const SizedBox(height: 32),
                            _buildSectionTitle('The Perfect Restaurants For You'),
                            const SizedBox(height: 16),
                            _buildCategoriesSection(),
                            const SizedBox(height: 32),
                            _buildSectionTitle('Reorder Once Again'),
                            const SizedBox(height: 16),
                            _buildTabBar(),
                            const SizedBox(height: 16),
                            _buildRestaurantsList(),
                            const SizedBox(height: 24),
                            _buildPopularTags(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isMenuOpen) _buildMenuOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: AnimatedOpacity(
        opacity: _appBarOpacity,
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Eatments'),
            Text(
              'Bhopal',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white.withOpacity(_appBarOpacity),
      elevation: 0,
      leading: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _menuAnimationController,
          color: Colors.black,
        ),
        onPressed: _toggleMenu,
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications, color: Colors.black),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuOverlay() {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  color: Colors.orange.withOpacity(0.1),
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuItem(Icons.person, 'Edit Profile', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        );
                      }),
                      _buildMenuItem(Icons.account_balance_wallet, 'My Accounts', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyAccountsPage()),
                        );
                      }),
                      _buildMenuItem(Icons.settings, 'Manage', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ManagePage()),
                        );
                      }),
                      _buildMenuItem(Icons.card_giftcard, 'Refer & Earn', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReferEarnPage()),
                        );
                      }),
                      _buildMenuItem(Icons.help, 'Help & Support', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpSupportPage()),
                        );
                      }),
                      _buildMenuItem(Icons.logout, 'Logout', () {
                        // Handle logout
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title),
      onTap: () {
        _toggleMenu();
        onTap();
      },
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExplorePage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(
              'Search for restaurants or cuisines...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categories[index]),
                  selected: _selectedCategoryIndex == index,
                  selectedColor: Colors.orange[100],
                  labelStyle: TextStyle(
                    color: _selectedCategoryIndex == index
                        ? Colors.orange[800]
                        : Colors.grey[800],
                    fontWeight: _selectedCategoryIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedCategoryIndex = selected ? index : 0;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.orange[100],
        ),
        labelColor: Colors.orange[800],
        unselectedLabelColor: Colors.grey[600],
        tabs: const [
          Tab(text: 'Nearby'),
          Tab(text: 'Popular'),
          Tab(text: 'New'),
        ],
        onTap: (index) {
          // Tab switching logic
        },
      ),
    );
  }

  Widget _buildRestaurantsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _restaurants.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildRestaurantCard(_restaurants[index]),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailsPage(restaurant: restaurant),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 150,
                color: Colors.grey[200],
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Placeholder for image
                    Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              restaurant['rating'].toString(),
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              color: Colors.green[800],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        restaurant['price'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant['address'],
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['distance'],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['deliveryTime'],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      if (restaurant['seatsAvailable'])
                        Row(
                          children: [
                            Icon(
                              Icons.chair,
                              color: Colors.orange[800],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Seats Available',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTagChip('Meeting'),
            _buildTagChip('Party'),
            _buildTagChip('Events'),
            _buildTagChip('Dating'),
            _buildTagChip('Adventures'),
            _buildTagChip('Family'),
            _buildTagChip('Celebration'),
            _buildTagChip('Business'),
          ],
        ),
      ],
    );
  }

  Widget _buildTagChip(String name) {
    return FilterChip(
      label: Text(name),
      onSelected: (bool selected) {
        // Filter by tag
      },
      selected: false,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.orange[100],
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExplorePage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingsPage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RewardsPage()),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange[800],
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      backgroundColor: Colors.white,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_online),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: 'Rewards',
        ),
      ],
    );
  }
}

class RestaurantDetailsPage extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailsPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurant['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.restaurant,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              restaurant['rating'].toString(),
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.star,
                              color: Colors.green[800],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        restaurant['price'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    restaurant['address'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Experience authentic North Indian flavors with a modern twist. Our chefs use traditional recipes with the finest ingredients to bring you a memorable dining experience.',
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Popular Dishes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDishCard('Butter Chicken', '₹320'),
                        _buildDishCard('Paneer Tikka', '₹280'),
                        _buildDishCard('Dal Makhani', '₹250'),
                        _buildDishCard('Garlic Naan', '₹60'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Tags',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: restaurant['tags']
                        .map<Widget>((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Book a Table',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishCard(String name, String price) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fastfood, size: 40),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: const Center(
        child: Text('Explore Page Content'),
      ),
    );
  }
}

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: const Center(
        child: Text('Bookings Page Content'),
      ),
    );
  }
}

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: const Center(
        child: Text('Rewards Page Content'),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications Page Content'),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Profile Page Content'),
      ),
    );
  }
}

class MyAccountsPage extends StatelessWidget {
  const MyAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Accounts'),
      ),
      body: const Center(
        child: Text('My Accounts Page Content'),
      ),
    );
  }
}

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage'),
      ),
      body: const Center(
        child: Text('Manage Page Content'),
      ),
    );
  }
}

class ReferEarnPage extends StatelessWidget {
  const ReferEarnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn'),
      ),
      body: const Center(
        child: Text('Refer & Earn Page Content'),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: const Center(
        child: Text('Help & Support Page Content'),
      ),
    );
  }
}