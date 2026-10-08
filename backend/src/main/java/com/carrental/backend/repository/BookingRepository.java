package com.carrental.backend.repository;

import com.carrental.backend.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByUserIdOrderByIdDesc(Integer userId);
    List<Booking> findAllByOrderByIdDesc();
}
