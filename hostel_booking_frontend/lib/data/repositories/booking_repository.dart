import 'package:hostel_booking_frontend/data/models/booking.dart';
import 'package:hostel_booking_frontend/data/providers/booking_providers.dart';

class BookingRepository {
  final BookingProviders provider;
  BookingRepository(this.provider);

  Future<List<Booking>> getAllBookings({required String token}) async {
    final List<dynamic> bookingListJson = await provider.getAllBookings(
      token: token,
    );
    return bookingListJson.map((json) => Booking.fromJson(json)).toList();
  }

  Future<Booking> getBookingById({
    required int id,
    required String token,
  }) async {
    final Map<String, dynamic> bookingJson = await provider.getBookingsById(
      id: id,
      token: token,
    );
    return Booking.fromJson(bookingJson);
  }

  Future<Map<String, dynamic>> addBooking({
    required int roomId,
    required int bookedBy,
    required DateTime bookedAt,
    required String token,
  }) async {
    try {
      return await provider.addBooking(
        roomId: roomId,
        bookedBy: bookedBy,
        bookedAt: bookedAt,
        token: token,
      );
    } catch (e) {
      rethrow;
    }
  }
}
