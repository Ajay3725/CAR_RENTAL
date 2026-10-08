package com.carrental.backend.dto;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class AuthResponse {
    private boolean success;
    private String message;
    private String error;
    private UserData user;

    public static class UserData {
        private Integer id;
        private String username;
        private String role;

        public UserData() {}

        public UserData(Integer id, String username, String role) {
            this.id = id;
            this.username = username;
            this.role = role;
        }

        public Integer getId() {
            return id;
        }

        public void setId(Integer id) {
            this.id = id;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }
    }

    public AuthResponse() {}

    public static AuthResponse ok(Integer id, String username, String role) {
        AuthResponse res = new AuthResponse();
        res.success = true;
        res.user = new UserData(id, username, role);
        return res;
    }

    public static AuthResponse error(String errorMessage) {
        AuthResponse res = new AuthResponse();
        res.success = false;
        res.error = errorMessage;
        res.message = errorMessage;
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

    public UserData getUser() {
        return user;
    }

    public void setUser(UserData user) {
        this.user = user;
    }
}
