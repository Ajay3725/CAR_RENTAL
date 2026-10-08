package com.carrental.backend.controller;

import com.carrental.backend.dto.ApiResponse;
import com.carrental.backend.dto.BookingConfirmRequest;
import com.carrental.backend.dto.BookingCreateRequest;
import com.carrental.backend.model.Booking;
import com.carrental.backend.service.BookingService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    // List all bookings
    @GetMapping({"/api/bookings", "/api/booking"})
    public ResponseEntity<List<Booking>> getAllBookings() {
        return ResponseEntity.ok(bookingService.getAllBookings());
    }

    // List bookings by user ID
    @GetMapping("/api/bookings/user/{userId}")
    public ResponseEntity<List<Booking>> getBookingsByUser(@PathVariable Integer userId) {
        return ResponseEntity.ok(bookingService.getBookingsByUserId(userId));
    }

    // Get single booking by ID
    @GetMapping("/api/bookings/{id}")
    public ResponseEntity<?> getBookingById(@PathVariable Integer id) {
        return bookingService.getBookingById(id)
                .<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Booking not found with ID: " + id)));
    }

    // Create a new pending booking
    @PostMapping({"/api/bookings", "/api/booking"})
    public ResponseEntity<ApiResponse> createBooking(@RequestBody BookingCreateRequest request) {
        try {
            Booking created = bookingService.createBooking(request);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.bookingCreated(created.getId(), "Booking stored successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Could not save booking."));
        }
    }

    // Confirm booking with payment and dates
    @PutMapping({"/api/booking", "/api/bookings/confirm"})
    public ResponseEntity<ApiResponse> confirmBooking(@RequestBody BookingConfirmRequest request) {
        try {
            bookingService.confirmBooking(request);
            return ResponseEntity.ok(ApiResponse.ok("Booking confirmed successfully."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Could not confirm booking."));
        }
    }
}
