import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class FetchAllBookingsRequested extends BookingEvent {
  final String token;
  const FetchAllBookingsRequested({required this.token});
}

class FetchBookingByIdRequested extends BookingEvent {
  final int bookingId;
  final String token;
  const FetchBookingByIdRequested({
    required this.bookingId,
    required this.token,
  });
}

class AddBookingRequested extends BookingEvent {
  final int roomId;
  final int bookedBy;
  final DateTime bookedAt;
  final String token;

  const AddBookingRequested({
    required this.roomId,
    required this.bookedBy,
    required this.bookedAt,
    required this.token,
  });
}
