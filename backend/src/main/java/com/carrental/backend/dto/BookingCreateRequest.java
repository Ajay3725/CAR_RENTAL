package com.carrental.backend.dto;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.Map;

public class BookingCreateRequest {
    private Integer userId;
    private Object carDetails;

    // Optional flat fields
    private String name;
    private Double price;
    private String mileage;
    private String seats;
    private String rating;
    private String image;

    private static final ObjectMapper MAPPER = new ObjectMapper();

    public BookingCreateRequest() {}

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Object getCarDetails() {
        return carDetails;
    }

    public void setCarDetails(Object carDetails) {
        this.carDetails = carDetails;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getMileage() {
        return mileage;
    }

    public void setMileage(String mileage) {
        this.mileage = mileage;
    }

    public String getSeats() {
        return seats;
    }

    public void setSeats(String seats) {
        this.seats = seats;
    }

    public String getRating() {
        return rating;
    }

    public void setRating(String rating) {
        this.rating = rating;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String toJsonString() {
        try {
            if (carDetails != null) {
                if (carDetails instanceof String str) {
                    return str;
                }
                return MAPPER.writeValueAsString(carDetails);
            }
            Map<String, Object> map = new HashMap<>();
            map.put("name", name);
            map.put("price", price);
            map.put("mileage", mileage);
            map.put("seats", seats);
            map.put("rating", rating);
            map.put("image", image);
            return MAPPER.writeValueAsString(map);
        } catch (Exception e) {
            return "{}";
        }
    }
}
