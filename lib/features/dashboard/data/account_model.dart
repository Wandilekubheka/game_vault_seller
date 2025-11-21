class AccountModel {
  final String sellerName;
  final String accountTitle;
  final String accountDescription;
  final double price;
  final double rating;
  final String accountId;
  final int salesCount;
  final List<String> imageUrls;
  final int likes;
  final DateTime createdAt = DateTime.now();
  final bool isAvailable;

  AccountModel({
    required this.sellerName,
    required this.accountTitle,
    required this.accountDescription,
    required this.price,
    required this.rating,
    required this.salesCount,
    required this.imageUrls,
    required this.accountId,
    this.likes = 0,
    this.isAvailable = true,
  });

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      accountId: map['accountId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      accountTitle: map['accountTitle'] ?? '',
      accountDescription: map['accountDescription'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      salesCount: map['salesCount'] ?? 0,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      likes: map['likes'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'sellerName': sellerName,
      'accountTitle': accountTitle,
      'accountDescription': accountDescription,
      'price': price,
      'rating': rating,
      'salesCount': salesCount,
      'imageUrls': imageUrls,
      'likes': likes,
      'isAvailable': isAvailable,
    };
  }

  AccountModel copyWith({
    String? sellerName,
    String? accountTitle,
    String? accountDescription,
    double? price,
    double? rating,
    int? salesCount,
    int? likes,
    bool? isAvailable,
    List<String>? imageUrls,
  }) {
    return AccountModel(
      accountId: accountId,
      sellerName: sellerName ?? this.sellerName,
      accountTitle: accountTitle ?? this.accountTitle,
      accountDescription: accountDescription ?? this.accountDescription,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
