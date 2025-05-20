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
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Your Points',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _points.toString(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _points / 2000,
                      backgroundColor: Colors.grey[200],
                      color: Colors.orange,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_points / 2000 * 100).toStringAsFixed(0)}% to next tier',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Rewards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: _rewards.length,
              itemBuilder: (context, index) {
                final reward = _rewards[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.card_giftcard,
                            color: Colors.orange[800],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          reward['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reward['description'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
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
                              ),
                            ),
                            ElevatedButton(
                              onPressed: reward['claimed'] || _points < reward['points']
                                  ? null
                                  : () {
                                setState(() {
                                  _points -= reward['points'];
                                  _rewards[index]['claimed'] = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: reward['claimed']
                                    ? Colors.grey[300]
                                    : Colors.orange[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                              ),
                              child: Text(
                                reward['claimed'] ? 'Claimed' : 'Redeem',
                                style: TextStyle(
                                  color: reward['claimed']
                                      ? Colors.grey[600]
                                      : Colors.white,
                                  fontSize: 12,
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
            ),
            const SizedBox(height: 24),
            const Text(
              'How to Earn Points',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildEarningMethod('Make a booking', '50 pts'),
            _buildEarningMethod('Dine at a restaurant', '100 pts'),
            _buildEarningMethod('Write a review', '30 pts'),
            _buildEarningMethod('Refer a friend', '200 pts'),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningMethod(String title, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 16,
              color: Colors.orange[800],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            points,
            style: TextStyle(
              color: Colors.orange[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}