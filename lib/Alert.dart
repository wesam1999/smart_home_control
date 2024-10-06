// ignore: file_names
class Alert {
  String id = '';
  String name = '';
  String notificraion = '';
  String description = '';
  String time = '';
  String img = '';
  String shortDescription = '';
  Alert(this.id, this.name, this.notificraion, this.description, this.time,
      this.img, this.shortDescription);

  Alert.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    notificraion = json['notificraion'] ?? '';
    description = json['shortDescription'] ?? '';
    time = json['dateTime'] ?? '';
    img = json['img'] ?? '';
    shortDescription = json['shortDescription'] ?? '';
  }
}
