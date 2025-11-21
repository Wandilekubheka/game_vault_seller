import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final String country;
  final double totalRevenue;
  final int totalSales;
  final int totalAccounts;
  final int totalCustomers;
  final double rating;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.country,
    this.totalRevenue = 0.0,
    this.totalSales = 0,
    this.totalAccounts = 0,
    this.totalCustomers = 0,
    this.profilePictureUrl,
    this.rating = 0,
  });

  static Future<String> getUserCountry() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('user_country') ?? 'South Africa';
  }

  Future<void> setUserCountry(String country) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('user_country', country);
  }

  static Future<UserModel> fromMap(Map<String, dynamic> map) async {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      country: await getUserCountry(),
      totalRevenue: map['totalRevenue']?.toDouble() ?? 0.0,
      totalSales: map['totalSales'] ?? 0,
      totalAccounts: map['totalAccounts'] ?? 0,
      totalCustomers: map['totalCustomers'] ?? 0,
      rating: map['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'country': country,
      'totalRevenue': totalRevenue,
      'totalSales': totalSales,
      'totalAccounts': totalAccounts,
      'totalCustomers': totalCustomers,
      'rating': rating,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? profilePictureUrl,
    DateTime? createdAt,
    String? country,
    double? totalRevenue,
    int? totalSales,
    int? totalAccounts,
    int? totalCustomers,
    double? rating,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      country: country ?? this.country,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalSales: totalSales ?? this.totalSales,
      totalAccounts: totalAccounts ?? this.totalAccounts,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      rating: rating ?? this.rating,
    );
  }

  factory UserModel.fromFirebaseUser(User user, String username) {
    // TODO: (Wandile) reevaluate the logic behind this code it might cause issues in future with international users

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      username: username,
      createdAt: DateTime.now(),
      country: 'South Africa',
      totalRevenue: 0.0,
      totalSales: 0,
      totalAccounts: 0,
      totalCustomers: 0,
      rating: 0,
    );
  }
}
