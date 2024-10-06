class device {
  String id = '';
  String diviceName = '';
  String type = '';
  String controlDeviceId = '';
  String maker = '';
  String locationInHouse = '';

  device(this.id, this.diviceName, this.type, this.controlDeviceId, this.maker,
      this.locationInHouse);

  device.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    diviceName = json['diviceName'] ?? '';
    type = json['type'] ?? '';
    controlDeviceId = json['controlDeviceId'] ?? '';
    maker = json['maker'] ?? '';
    locationInHouse = json['locationInHouse'] ?? '';
  }
}
