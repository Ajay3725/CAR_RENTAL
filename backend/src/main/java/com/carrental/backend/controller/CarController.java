package com.carrental.backend.controller;

import com.carrental.backend.dto.ApiResponse;
import com.carrental.backend.dto.CarRequest;
import com.carrental.backend.model.Car;
import com.carrental.backend.service.CarService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
public class CarController {

    private final CarService carService;

    public CarController(CarService carService) {
        this.carService = carService;
    }

    // Get all cars
    @GetMapping({"/api/cars", "/api/admin/cars"})
    public ResponseEntity<List<Car>> getAllCars() {
        return ResponseEntity.ok(carService.getAllCars());
    }

    // Get car by ID
    @GetMapping("/api/cars/{id}")
    public ResponseEntity<?> getCarById(@PathVariable Integer id) {
        return carService.getCarById(id)
                .<ResponseEntity<?>>map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Car not found with ID: " + id)));
    }

    // Add a new car
    @PostMapping({"/api/cars", "/api/cars/add", "/api/admin/cars/add"})
    public ResponseEntity<?> addCar(@RequestBody CarRequest request) {
        try {
            Car created = carService.addCar(request);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("car", created);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Could not add car."));
        }
    }

    // Update car
    @PutMapping({"/api/cars", "/api/cars/update", "/api/admin/cars/update"})
    public ResponseEntity<?> updateCar(@RequestBody CarRequest request) {
        try {
            Car updated = carService.updateCar(request);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("car", updated);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Could not update car."));
        }
    }

    @PutMapping("/api/cars/{id}")
    public ResponseEntity<?> updateCarById(@PathVariable Integer id, @RequestBody CarRequest request) {
        request.setId(id);
        return updateCar(request);
    }

    // Delete car by ID path variable
    @DeleteMapping("/api/cars/{id}")
    public ResponseEntity<?> deleteCarById(@PathVariable Integer id) {
        boolean deleted = carService.deleteCar(id);
        if (deleted) {
            return ResponseEntity.ok(ApiResponse.ok("Car deleted successfully."));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error("Car not found."));
        }
    }

    // Delete car by ID in body
    @DeleteMapping({"/api/admin/cars/delete", "/api/cars/delete"})
    public ResponseEntity<?> deleteCarFromBody(@RequestBody(required = false) Map<String, Object> body,
                                              @RequestParam(value = "id", required = false) Integer paramId) {
        Integer id = paramId;
        if (id == null && body != null && body.containsKey("id")) {
            id = Integer.valueOf(body.get("id").toString());
        }

        if (id == null) {
            return ResponseEntity.badRequest().body(ApiResponse.error("A valid car id is required."));
        }

        boolean deleted = carService.deleteCar(id);
        if (deleted) {
            return ResponseEntity.ok(ApiResponse.ok("Car deleted successfully."));
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ApiResponse.error("Car not found."));
        }
    }
}
