class ProductModel {
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final num rate;
  final int reviews;

  ProductModel({
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rate,
    required this.reviews,
  });

  factory ProductModel.fromApi(Map json) {
    return ProductModel(
      title: json['title'] ?? 'Untitled',
      price: json['price'] ?? 0,
      description: json['description'] ?? 'No description',
      category: json['category'] ?? 'Unknown',
      image: json['image'] ??
          'https://www.shutterstock.com/image-vector/mystery-contest-cardboard-box-question-260nw-2472419999.jpg',
      rate: json['rating']['rate'] ?? 0.0,
      reviews: json['rating']['count']
    );
  }
}
