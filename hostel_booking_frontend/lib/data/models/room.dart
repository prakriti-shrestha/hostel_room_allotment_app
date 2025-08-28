class Room {
  final int? id;
  final int buildingId;
  final String roomNumber;
  final String type; // AC or Non-AC
  final int bedsTotal;
  final int occupied;
  final bool isApartment;
  final String nationalityRestriction;

  Room({
    this.id,
    required this.buildingId,
    required this.roomNumber,
    required this.type,
    required this.bedsTotal,
    required this.occupied,
    required this.isApartment,
    required this.nationalityRestriction,
  });

  int get bedsAvailable => bedsTotal - occupied;
  bool get isAvailable => bedsAvailable > 0;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['room_id'] ?? json['id'],
      buildingId: json['building_id'],
      roomNumber: json['room_number'],
      type: json['type'],
      bedsTotal: json['beds_total'],
      occupied:
          json['occupied'] ?? (json['beds_total'] - json['beds_available']),
      isApartment: (json['apartment'] ?? 0) != 0,
      nationalityRestriction: json['nationality_restriction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "building_id": buildingId,
      "room_number": roomNumber,
      "type": type,
      "beds_total": bedsTotal,
      "occupied": occupied,
      "apartment": isApartment ? 1 : 0,
      "nationality_restriction": nationalityRestriction,
    };
  }
}
