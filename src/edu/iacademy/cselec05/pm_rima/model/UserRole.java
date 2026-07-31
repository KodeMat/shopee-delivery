package edu.iacademy.cselec05.pm_rima.model;

public enum UserRole {
    ADMIN,
    SUPERVISOR;

    public static UserRole fromString(String roleStr) {
        if (roleStr == null) return SUPERVISOR;
        try {
            return UserRole.valueOf(roleStr.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return SUPERVISOR;
        }
    }
}
