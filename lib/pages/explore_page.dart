import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  String? _selectedCuisine;
  final List<Map<String, dynamic>> eventTypes = [
    {'name': 'Adventure', 'icon': Icons.terrain},
    {'name': 'Dating', 'icon': Icons.favorite},
    {'name': 'Meeting', 'icon': Icons.people},
    {'name': 'Party', 'icon': Icons.celebration},
    {'name': 'Event', 'icon': Icons.event},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.restaurant_menu, 'name': 'North Indian', 'color': Colors.deepOrange},
    {'icon': Icons.ramen_dining, 'name': 'Chinese', 'color': Colors.redAccent},
    {'icon': Icons.local_pizza, 'name': 'Italian', 'color': Colors.amber},
    {'icon': Icons.soup_kitchen, 'name': 'South Indian', 'color': Colors.orange},
    {'icon': Icons.cake, 'name': 'Desserts', 'color': Colors.pinkAccent},
    {'icon': Icons.local_cafe, 'name': 'Cafe', 'color': Colors.brown},
    {'icon': Icons.wine_bar, 'name': 'Bar', 'color': Colors.deepPurple},
    {'icon': Icons.fastfood, 'name': 'Fast Food', 'color': Colors.red},
  ];

  final List<Map<String, dynamic>> _trendingRestaurants = [
    {
      'name': 'Spice Trail',
      'rating': 4.6,
      'type': 'North Indian • Chinese',
      'image': 'assets/restaurant4.jpg',
      'price': '₹₹',
      'distance': '1.2 km',
    },
    {
      'name': 'Pasta Palace',
      'rating': 4.3,
      'type': 'Italian • Continental',
      'image': 'assets/restaurant5.jpg',
      'price': '₹₹₹',
      'distance': '0.8 km',
    },
    {
      'name': 'The Biryani House',
      'rating': 4.8,
      'type': 'Hyderabadi • Mughlai',
      'image': 'assets/restaurant6.jpg',
      'price': '₹₹₹₹',
      'distance': '2.1 km',
    },
    {
      'name': 'Lakeview Bistro',
      'rating': 4.7,
      'type': 'Multi-cuisine',
      'image': 'assets/restaurant7.jpg',
      'price': '₹₹₹₹₹',
      'distance': '3.5 km',
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
      backgroundColor: Colors.orange[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: _appBarElevation,
            pinned: true,
            floating: true,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Explore',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.orange[50]!,
                      Colors.orange[100]!,
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(150),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Hero(
                      tag: 'search_bar',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              hintText: 'Search for exclusive experiences...',
                              hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins'),
                              prefixIcon: Icon(Icons.search, color: Colors.orange[800]),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildCuisineDropdown(),
                        ),
                      ],
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
                    const SizedBox(height: 0),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _buildCategoriesGrid(),
                    ),
                    const SizedBox(height: 15),
                    _buildSectionHeader('Trending Luxury Spots'),
                    const SizedBox(height: 15),
                    _buildTrendingList(),
                    const SizedBox(height: 28),
                    _buildSectionHeader('Popular Picks Around You'),
                    const SizedBox(height: 15),
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

  Widget _buildFilterDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedFilter != null
              ? Colors.orange.withOpacity(0.8)
              : Colors.orange.shade200,
          width: _selectedFilter != null ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _selectedFilter,
          hint: const Text('Event type', style: TextStyle(fontFamily: 'Poppins')),
          onChanged: (String? value) {
            setState(() {
              _selectedFilter = value;
              HapticFeedback.lightImpact();
            });
          },
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Events', style: TextStyle(fontFamily: 'Poppins')),
            ),
            ...eventTypes.map<DropdownMenuItem<String>>((event) {
              return DropdownMenuItem<String>(
                value: event['name'],
                child: Row(
                  children: [
                    Icon(event['icon'], size: 18, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Text(event['name'], style: const TextStyle(fontFamily: 'Poppins')),
                  ],
                ),
              );
            }).toList(),
          ],
          buttonStyleData: const ButtonStyleData(
            height: 50,
            padding: EdgeInsets.only(left: 16, right: 8),
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
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.arrow_drop_down, color: Colors.orange[800]),
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

  Widget _buildCuisineDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _selectedCuisine != null
              ? Colors.orange.withOpacity(0.8)
              : Colors.orange.shade200,
          width: _selectedCuisine != null ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _selectedCuisine,
          hint: const Text('Cuisine', style: TextStyle(fontFamily: 'Poppins')),
          onChanged: (String? value) {
            setState(() {
              _selectedCuisine = value;
              HapticFeedback.lightImpact();
            });
          },
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Cuisines', style: TextStyle(fontFamily: 'Poppins')),
            ),
            ..._categories.map<DropdownMenuItem<String>>((category) {
              return DropdownMenuItem<String>(
                value: category['name'],
                child: Row(
                  children: [
                    Icon(category['icon'], size: 20, color: category['color']),
                    const SizedBox(width: 10),
                    Text(category['name'], style: const TextStyle(fontFamily: 'Poppins')),
                  ],
                ),
              );
            }).toList(),
          ],
          buttonStyleData: const ButtonStyleData(
            height: 50,
            padding: EdgeInsets.only(left: 16, right: 8),
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
                    spreadRadius: 2),
              ],
            ),
            offset: const Offset(0, -10),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(Icons.arrow_drop_down, color: Colors.orange[800]),
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

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            letterSpacing: 0.5,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'View All',
            style: TextStyle(
              color: Colors.orange[800],
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
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
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCuisine = category['name'];
            });
            HapticFeedback.lightImpact();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _selectedCuisine == category['name']
                  ? Colors.orange[50]
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedCuisine == category['name']
                    ? Colors.orange.withOpacity(0.8)
                    : Colors.orange.withOpacity(0.1),
                width: _selectedCuisine == category['name'] ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: category['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category['icon'], color: category['color'], size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _trendingRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _trendingRestaurants[index];
          return Container(
            width: 180,
            margin: EdgeInsets.only(right: index == _trendingRestaurants.length - 1 ? 0 : 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.orange[100]!,
                            Colors.orange[200]!,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.restaurant, size: 50, color: Colors.white),
                      ),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant['type'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange[800], size: 16),
                              const SizedBox(width: 4),
                              Text(
                                restaurant['rating'].toString(),
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            restaurant['distance'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
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
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.restaurant, color: Colors.orange[800]),
            ),
            title: Text(
              'Popular Restaurant ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            subtitle: const Text(
              'North Indian • Chinese • Italian',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.orange[800]),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            onTap: () {
              HapticFeedback.lightImpact();
            },
          ),
        );
      },
    );
  }
}