package com.carrental.backend.service;

import com.carrental.backend.dto.CarRequest;
import com.carrental.backend.model.Car;
import com.carrental.backend.repository.CarRepository;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class CarService {

    private final CarRepository carRepository;

    public CarService(CarRepository carRepository) {
        this.carRepository = carRepository;
    }

    public List<Car> getAllCars() {
        return carRepository.findAllByOrderByIdAsc();
    }

    public Optional<Car> getCarById(Integer id) {
        return carRepository.findById(id);
    }

    public Car addCar(CarRequest req) {
        if (req.getName() == null || req.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Car name is required.");
        }
        if (req.getPrice() == null || req.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("A valid non-negative car price is required.");
        }

        Car car = new Car(
                req.getName().trim(),
                req.getPrice(),
                req.getImage() != null ? req.getImage() : "/placeholder.jpg",
                req.getMileage() != null ? req.getMileage() : "",
                req.getSeats() != null ? req.getSeats() : "",
                req.getRating() != null ? req.getRating() : ""
        );

        return carRepository.save(car);
    }

    public Car updateCar(CarRequest req) {
        if (req.getId() == null) {
            throw new IllegalArgumentException("Car ID is required for update.");
        }
        Car existing = carRepository.findById(req.getId())
                .orElseThrow(() -> new IllegalArgumentException("Car not found with ID: " + req.getId()));

        if (req.getName() != null && !req.getName().trim().isEmpty()) {
            existing.setName(req.getName().trim());
        }
        if (req.getPrice() != null && req.getPrice().compareTo(BigDecimal.ZERO) >= 0) {
            existing.setPrice(req.getPrice());
        }
        if (req.getImage() != null) {
            existing.setImage(req.getImage());
        }
        if (req.getMileage() != null) {
            existing.setMileage(req.getMileage());
        }
        if (req.getSeats() != null) {
            existing.setSeats(req.getSeats());
        }
        if (req.getRating() != null) {
            existing.setRating(req.getRating());
        }

        return carRepository.save(existing);
    }

    public boolean deleteCar(Integer id) {
        if (carRepository.existsById(id)) {
            carRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
