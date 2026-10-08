package com.carrental.backend.service;

import com.carrental.backend.model.User;
import com.carrental.backend.repository.UserRepository;
import com.carrental.backend.util.PasswordUtil;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Optional<User> authenticate(String username, String password) {
        if (username == null || password == null) {
            return Optional.empty();
        }

        Optional<User> userOpt = userRepository.findByUsernameIgnoreCase(username.trim());
        if (userOpt.isEmpty()) {
            return Optional.empty();
        }

        User user = userOpt.get();
        if (PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
            return Optional.of(user);
        }

        return Optional.empty();
    }

    public User register(String username, String password, String role) {
        if (username == null || username.trim().length() < 3 || username.trim().length() > 50) {
            throw new IllegalArgumentException("Username must be between 3 and 50 characters.");
        }
        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException("Password must be at least 8 characters long.");
        }

        String trimmedUsername = username.trim();
        if (userRepository.existsByUsernameIgnoreCase(trimmedUsername)) {
            throw new IllegalStateException("Username is already taken.");
        }

        String assignedRole = "admin".equalsIgnoreCase(role) ? "admin" : "user";
        String passwordHash = PasswordUtil.hashPassword(password);

        User newUser = new User(trimmedUsername, passwordHash, assignedRole);
        return userRepository.save(newUser);
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> findById(Integer id) {
        return userRepository.findById(id);
    }
}
