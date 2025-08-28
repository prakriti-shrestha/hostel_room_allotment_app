class Booking {
  final int bookingId;
  final int roomId;
  final DateTime bookedAt;
  final int bookedBy;
  final String bookedByName;
  final String roomNumber;

  Booking({
    required this.bookingId,
    required this.roomId,
    required this.bookedAt,
    required this.bookedBy,
    required this.bookedByName,
    required this.roomNumber,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      roomId: json['room_id'],
      bookedAt: DateTime.parse(json['booked_at']),
      bookedBy: json['booked_by'],
      bookedByName: json['booked_by_name'],
      roomNumber: json['room_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'room_id': roomId,
      'booked_at': bookedAt.toIso8601String(),
      'booked_by': bookedBy,
      'booked_by_name': bookedByName,
      'room_number': roomNumber,
    };
  }
}
