import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _points = 1250;

  final List<Map<String, dynamic>> _rewards = [
    {
      'title': '10% Off',
      'description': 'Get 10% off on your next order',
      'points': 200,
      'claimed': false,
    },
    {
      'title': 'Free Dessert',
      'description': 'Get a free dessert with any main course',
      'points': 350,
      'claimed': true,
    },
    {
      'title': '20% Off',
      'description': 'Get 20% off on orders above ₹1000',
      'points': 500,
      'claimed': false,
    },
    {
      'title': 'Free Drink',
      'description': 'Get a free soft drink with any meal',
      'points': 150,
      'claimed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Rewards',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPointsCard(),
            const SizedBox(height: 24),
            const Text(
              'Available Rewards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            _buildRewardsGrid(),
            const SizedBox(height: 32),
            const Text(
              'How to Earn Points',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            _buildEarningMethod('Make a booking', '50 pts'),
            _buildEarningMethod('Dine at a restaurant', '100 pts'),
            _buildEarningMethod('Write a review', '30 pts'),
            _buildEarningMethod('Refer a friend', '200 pts'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Card(
      elevation: 3,
      shadowColor: Colors.orange.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Text(
              'Your Points',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$_points',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _points / 2000,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_points / 2000 * 100).toStringAsFixed(0)}% to next tier',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _rewards.length,
      itemBuilder: (context, index) {
        final reward = _rewards[index];
        final isClaimed = reward['claimed'];
        final canRedeem = _points >= reward['points'];

        return Card(
          elevation: 2,
          shadowColor: Colors.orange.withOpacity(0.08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.card_giftcard, color: Colors.orange[800]),
                ),
                const SizedBox(height: 16),
                Text(
                  reward['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reward['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${reward['points']} pts',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isClaimed || !canRedeem
                          ? null
                          : () {
                        setState(() {
                          _points -= reward['points'] as int;
                          _rewards[index]['claimed'] = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isClaimed ? Colors.grey[300] : Colors.orange[800],
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isClaimed ? 'Claimed' : 'Redeem',
                        style: TextStyle(
                          color: isClaimed ? Colors.grey[600] : Colors.white,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEarningMethod(String title, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, size: 16, color: Colors.orange[800]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Text(
            points,
            style: TextStyle(
              color: Colors.orange[800],
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
