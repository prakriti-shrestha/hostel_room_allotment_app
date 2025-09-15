import 'package:equatable/equatable.dart';
import 'package:hostel_booking_frontend/data/models/booking.dart';
import 'package:hostel_booking_frontend/data/models/room.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoadSuccess extends BookingState {
  final List<Booking> bookings;
  const BookingsLoadSuccess({required this.bookings});
}

class BookingLoadSuccess extends BookingState {
  final Booking booking;
  const BookingLoadSuccess({required this.booking});
}

class BookingAddSuccess extends BookingState {
  final Room bookedRoom;
  const BookingAddSuccess({required this.bookedRoom});
}

class BookingFailure extends BookingState {
  final String error;
  const BookingFailure({required this.error});
}
