class News {
  String id = '';
  String title = '';
  String description = '';
  String time = '';
  String img = '';
  String name = '';
  String shortDescription = '';
  News(this.id, this.title, this.description, this.time, this.img, this.name,
      this.shortDescription);

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    time = json['time'] ?? '';
    img = json['img'] ?? '';
    name = json['name'] ?? '';
    shortDescription = json['shortDescription'] ?? '';
  }
}
