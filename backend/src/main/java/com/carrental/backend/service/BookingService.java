package com.carrental.backend.service;

import com.carrental.backend.dto.BookingConfirmRequest;
import com.carrental.backend.dto.BookingCreateRequest;
import com.carrental.backend.model.Booking;
import com.carrental.backend.repository.BookingRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;

    public BookingService(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    public List<Booking> getAllBookings() {
        return bookingRepository.findAllByOrderByIdDesc();
    }

    public List<Booking> getBookingsByUserId(Integer userId) {
        return bookingRepository.findByUserIdOrderByIdDesc(userId);
    }

    public Booking createBooking(BookingCreateRequest req) {
        String carDetailsJson = req.toJsonString();
        Booking booking = new Booking(req.getUserId(), carDetailsJson);
        return bookingRepository.save(booking);
    }

    public Booking confirmBooking(BookingConfirmRequest req) {
        if (req.getBookingId() == null) {
            throw new IllegalArgumentException("Booking ID is required.");
        }

        Booking booking = bookingRepository.findById(req.getBookingId())
                .orElseThrow(() -> new IllegalArgumentException("Booking not found with ID: " + req.getBookingId()));

        if (req.getTotal() != null && req.getTotal().compareTo(BigDecimal.ZERO) > 0) {
            booking.setTotalAmount(req.getTotal());
        }

        if (req.getPayment() != null && !req.getPayment().trim().isEmpty()) {
            booking.setPaymentMethod(req.getPayment().trim());
        }

        if (req.getPickupDate() != null && !req.getPickupDate().trim().isEmpty()) {
            try {
                booking.setPickupDate(LocalDate.parse(req.getPickupDate().trim()));
            } catch (DateTimeParseException ignored) {}
        }

        if (req.getReturnDate() != null && !req.getReturnDate().trim().isEmpty()) {
            try {
                booking.setReturnDate(LocalDate.parse(req.getReturnDate().trim()));
            } catch (DateTimeParseException ignored) {}
        }

        booking.setStatus("confirmed");
        return bookingRepository.save(booking);
    }

    public Optional<Booking> getBookingById(Integer id) {
        return bookingRepository.findById(id);
    }
}
