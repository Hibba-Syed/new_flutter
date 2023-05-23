class Category {
  String? title;
  String? image;

  Category({required this.title, this.image});
}

List<Category> categories = [
  Category(
      title: "GROCERY",
      image: 'assets/image/grocery.jpg'),
  Category(
      title: "ELECTRONICS",
      image: 'assets/image/electronics.jpg'),
  Category(
      title: "COSMETICS",
      image: 'assets/image/cosmetics.jpg'),
  Category(
      title: "PHARMACY",
      image: 'assets/image/pharmacy.jpg'),
  Category(
      title: "GARMENTS",
      image: 'assets/image/garments.jpg'),
];
