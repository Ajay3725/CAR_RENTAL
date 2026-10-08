package com.carrental.backend.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse {
    private boolean success;
    private String message;
    private String error;
    private Integer bookingId;
    private Object data;

    public ApiResponse() {}

    public ApiResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public static ApiResponse ok(String message) {
        return new ApiResponse(true, message);
    }

    public static ApiResponse error(String error) {
        ApiResponse res = new ApiResponse(false, null);
        res.error = error;
        res.message = error;
        return res;
    }

    public static ApiResponse bookingCreated(Integer bookingId, String message) {
        ApiResponse res = new ApiResponse(true, message);
        res.bookingId = bookingId;
        return res;
    }

    public static ApiResponse withData(Object data) {
        ApiResponse res = new ApiResponse(true, null);
        res.data = data;
        return res;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
