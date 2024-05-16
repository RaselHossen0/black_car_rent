import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rent_a_car/widgets/custom_textfield.dart';

class Review {
  String uid;
  String name;
  String review;
  double rating;

  Review(
      {required this.uid,
      required this.name,
      required this.review,
      required this.rating});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'review': review,
        'rating': rating,
      };

  static Review fromJson(Map<String, dynamic> json) => Review(
        uid: json['uid'],
        name: json['name'],
        review: json['review'],
        rating: json['rating'].toDouble(),
      );
}

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _reviewController = TextEditingController();
  double _currentRating = 4.0;
  final dbRef = FirebaseDatabase.instance.ref().child("reviews");
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchReviews();
  }

  void _fetchReviews() async {
    dbRef.onValue.listen((event) {
      final allReviews = <Review>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      data?.forEach((key, value) {
        final review = Review.fromJson(Map<String, dynamic>.from(value));
        allReviews.add(review);
      });
      setState(() {
        _reviews = allReviews;
      });
    });
  }

  void _postReview() async {
    final user = FirebaseAuth.instance.currentUser!;
    final newReview = Review(
      uid: user.uid,
      name: user.displayName ?? 'Anonymous',
      review: _reviewController.text,
      rating: _currentRating,
    );

    dbRef.push().set(newReview.toJson()).then((_) {
      _reviewController.clear();
      _tabController.animateTo(0);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Review posted successfully')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Review Page'),
        bottom: TabBar(
          labelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[850],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Reviews',
            ),
            Tab(text: 'Add Review'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return ListTile(
                title: Text(review.name),
                subtitle: Text(review.review),
                trailing: RatingBarIndicator(
                  rating: review.rating,
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Image.network(
                    'https://img.freepik.com/premium-vector/customer-review-great-design-any-purposes-flat-illustration-with-customer-review_194782-1172.jpg'),
                SizedBox(height: 20),
                CustomTextField(
                    controller: _reviewController,
                    hintText: 'Enter your review'),
                SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: _currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _currentRating = rating;
                    });
                  },
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: _postReview,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Post Review',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }
}
