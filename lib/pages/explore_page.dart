// Updated ExplorePage without Sidebar and with Filter Dropdown
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;

class ExplorePageWithSidebar extends StatefulWidget {
  const ExplorePageWithSidebar({super.key});

  @override
  State<ExplorePageWithSidebar> createState() => _ExplorePageWithSidebarState();
}

class _ExplorePageWithSidebarState extends State<ExplorePageWithSidebar> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  double _appBarElevation = 0.0;

  String? _selectedFilter;
  final List<String> _filterOptions = ['Adventure', 'Dating', 'Event', 'Party', 'Meeting'];

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.restaurant_menu, 'name': 'North Indian'},
    {'icon': Icons.ramen_dining, 'name': 'Chinese'},
    {'icon': Icons.local_pizza, 'name': 'Italian'},
    {'icon': Icons.soup_kitchen, 'name': 'South Indian'},
    {'icon': Icons.cake, 'name': 'Desserts'},
    {'icon': Icons.local_cafe, 'name': 'Cafe'},
    {'icon': Icons.wine_bar, 'name': 'Bar'},
    {'icon': Icons.fastfood, 'name': 'Fast Food'},
  ];

  final List<Map<String, dynamic>> _trendingRestaurants = [
    {
      'name': 'Spice Trail',
      'rating': 4.6,
      'type': 'North Indian • Chinese',
      'image': 'assets/restaurant4.jpg',
    },
    {
      'name': 'Pasta Palace',
      'rating': 4.3,
      'type': 'Italian • Continental',
      'image': 'assets/restaurant5.jpg',
    },
    {
      'name': 'The Biryani House',
      'rating': 4.8,
      'type': 'Hyderabadi • Mughlai',
      'image': 'assets/restaurant6.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo,
      ),
    );

    _scrollController.addListener(() {
      setState(() {
        _appBarElevation = (_scrollController.offset / 100).clamp(0.0, 4.0);
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: _appBarElevation,
            pinned: true,
            floating: true,
            title: const Text(
              'Explore',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Hero(
                      tag: 'search_bar',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for exclusive experiences...',
                              prefixIcon: Icon(Icons.search, color: Colors.orange),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        hint: const Text('Filter by type'),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _filterOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFilter = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Curated Categories'),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _buildCategoriesGrid(),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Trending Luxury Spots'),
                    const SizedBox(height: 16),
                    _buildTrendingList(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Popular Picks Around You'),
                    const SizedBox(height: 16),
                    _buildPopularList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'View All',
            style: TextStyle(color: Colors.orange),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(category['icon'], color: Colors.orange[800], size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              category['name'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[800]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrendingList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _trendingRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _trendingRestaurants[index];
          return Container(
            width: 280,
            margin: EdgeInsets.only(right: index == _trendingRestaurants.length - 1 ? 0 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.restaurant, size: 50, color: Colors.grey[400]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant['type'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, color: Colors.grey),
            ),
            title: const Text(
              'Popular Restaurant Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
            ),
            subtitle: const Text('North Indian • Chinese • Italian'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            onTap: () {},
          ),
        );
      },
    );
  }
}