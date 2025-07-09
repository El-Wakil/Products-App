class LapModel {
  final String id;
  final String status;
  final String category;
  final String name;
  final double price;
  final String description;
  final String image;
  final int stock;
  final int sales;
  final List<String> images;

  LapModel({
    required this.id,
    required this.status,
    required this.category,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.images,
    required this.stock,
    required this.sales,
  });

//   factory LapModel.fromJson(Map<String, dynamic> json) {
//     return LapModel(
//       id: json['_id'] ?? '',
//       status: json['status'] ?? '',
//       category: json['category'] ?? '',
//       name: json['name'] ?? '',
//       price: (json['price'] as num).toDouble(),
//       description: json['description'] ?? '',
//       image: json['image'] ?? '',
//       images: List<String>.from(json['images'] ?? []),
//     );
//   }
// }

  factory LapModel.fromJson(Map<String, dynamic> json) {
    return LapModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      stock: json['countInStock'] ?? 0,
      status: json['status'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      sales: json['sales'] ?? 0,
    );
  }
  }