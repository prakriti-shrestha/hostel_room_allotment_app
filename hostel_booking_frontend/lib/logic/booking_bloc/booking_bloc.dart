import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_booking_frontend/data/repositories/booking_repository.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_event.dart';
import 'package:hostel_booking_frontend/logic/booking_bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    // --- Fetch All Bookings Handler ---
    on<FetchAllBookingsRequested>((event, emit) async {
      emit(BookingLoading());
      try {
        final bookings = await repository.getAllBookings(token: event.token);
        emit(BookingsLoadSuccess(bookings: bookings));
      } catch (e) {
        emit(BookingFailure(error: e.toString()));
      }
    });

    // --- Fetch Booking By ID Handler ---
    on<FetchBookingByIdRequested>((event, emit) async {
      emit(BookingLoading());
      try {
        final booking = await repository.getBookingById(
          id: event.bookingId,
          token: event.token,
        );
        emit(BookingLoadSuccess(booking: booking));
      } catch (e) {
        emit(BookingFailure(error: e.toString()));
      }
    });

    // --- Add New Booking Handler ---
    on<AddBookingRequested>((event, emit) async {
      emit(BookingLoading());
      try {
        await repository.addBooking(
          roomId: event.roomId,
          bookedBy: event.bookedBy,
          bookedAt: event.bookedAt,
          token: event.token,
        );
        emit(BookingAddSuccess());
      } catch (e) {
        emit(BookingFailure(error: e.toString()));
      }
    });
  }
}
