package com.carrental.backend.controller;

import com.carrental.backend.dto.AuthResponse;
import com.carrental.backend.dto.LoginRequest;
import com.carrental.backend.dto.SignupRequest;
import com.carrental.backend.model.User;
import com.carrental.backend.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping({"/api", "/api/auth"})
@CrossOrigin
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest request) {
        if (request.getUsername() == null || request.getPassword() == null) {
            return ResponseEntity.badRequest().body(AuthResponse.error("Username and password are required."));
        }

        Optional<User> userOpt = userService.authenticate(request.getUsername(), request.getPassword());
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(AuthResponse.error("Invalid username or password."));
        }

        User user = userOpt.get();
        return ResponseEntity.ok(AuthResponse.ok(user.getId(), user.getUsername(), user.getRole()));
    }

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> signup(@RequestBody SignupRequest request) {
        try {
            User newUser = userService.register(request.getUsername(), request.getPassword(), request.getRole());
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(AuthResponse.ok(newUser.getId(), newUser.getUsername(), newUser.getRole()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(AuthResponse.error(e.getMessage()));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(AuthResponse.error(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(AuthResponse.error("Could not register user."));
        }
    }

    @GetMapping("/users")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        // Hide password hashes before returning
        for (User u : users) {
            u.setPasswordHash("[PROTECTED]");
        }
        return ResponseEntity.ok(users);
    }
}

