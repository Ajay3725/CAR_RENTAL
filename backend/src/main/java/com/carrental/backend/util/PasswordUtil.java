package com.carrental.backend.util;

import org.bouncycastle.crypto.generators.SCrypt;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.HexFormat;

public class PasswordUtil {

    private static final int KEY_LENGTH = 64;
    private static final int COST_N = 16384;
    private static final int BLOCK_SIZE_R = 8;
    private static final int PARALLELIZATION_P = 1;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public static String hashPassword(String password) {
        byte[] saltBytes = new byte[16];
        SECURE_RANDOM.nextBytes(saltBytes);
        String salt = HexFormat.of().formatHex(saltBytes);

        byte[] hash = SCrypt.generate(
                password.getBytes(StandardCharsets.UTF_8),
                salt.getBytes(StandardCharsets.UTF_8),
                COST_N,
                BLOCK_SIZE_R,
                PARALLELIZATION_P,
                KEY_LENGTH
        );

        String hexHash = HexFormat.of().formatHex(hash);
        return "scrypt$" + salt + "$" + hexHash;
    }

    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || storedHash == null) {
            return false;
        }

        // Direct match fallback for plaintext passwords in MySQL Workbench
        if (password.equals(storedHash)) {
            return true;
        }

        String[] parts = storedHash.split("\\$");
        if (parts.length != 3 || !"scrypt".equals(parts[0])) {
            return false;
        }

        String salt = parts[1];
        String expectedHex = parts[2];

        byte[] expected = HexFormat.of().parseHex(expectedHex);
        if (expected.length != KEY_LENGTH) {
            return false;
        }

        byte[] actual = SCrypt.generate(
                password.getBytes(StandardCharsets.UTF_8),
                salt.getBytes(StandardCharsets.UTF_8),
                COST_N,
                BLOCK_SIZE_R,
                PARALLELIZATION_P,
                KEY_LENGTH
        );

        return MessageDigest.isEqual(actual, expected);
    }
}

