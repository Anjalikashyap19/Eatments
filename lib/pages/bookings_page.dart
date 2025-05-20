import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'id': '#EB12345',
      'restaurant': 'Twist of Tadka',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '7:30 PM',
      'people': 4,
      'status': 'Confirmed',
      'image': 'assets/restaurant1.jpg',
    },
    {
      'id': '#EB12346',
      'restaurant': 'Spice Garden',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '8:00 PM',
      'people': 2,
      'status': 'Confirmed',
      'image': 'assets/restaurant2.jpg',
    },
  ];

  final List<Map<String, dynamic>> _pastBookings = [
    {
      'id': '#EB12344',
      'restaurant': 'Royal Treat',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'time': '7:00 PM',
      'people': 6,
      'status': 'Completed',
      'image': 'assets/restaurant3.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange[800],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.orange[800],
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(_upcomingBookings),
          _buildBookingsList(_pastBookings),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Map<String, dynamic>> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Show booking details
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/restaurant1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['restaurant'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${DateFormat('MMM dd, yyyy').format(booking['date'])} • ${booking['time']}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: booking['status'] == 'Confirmed'
                              ? Colors.green[50]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          booking['status'],
                          style: TextStyle(
                            color: booking['status'] == 'Confirmed'
                                ? Colors.green[800]
                                : Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking['id'],
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${booking['people']} people',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}