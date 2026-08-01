package edu.iacademy.cselec05.pm_rima.dao;

import edu.iacademy.cselec05.pm_rima.model.User;
import edu.iacademy.cselec05.pm_rima.model.UserRole;
import edu.iacademy.cselec05.pm_rima.util.DatabaseConfig;
import edu.iacademy.cselec05.pm_rima.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static final UserDAO INSTANCE = new UserDAO();

    private UserDAO() {
        initTable();
    }

    public static UserDAO getInstance() {
        return INSTANCE;
    }

    private void initTable() {
        String sqlUsers = "CREATE TABLE IF NOT EXISTS users ("
                + "user_id INT AUTO_INCREMENT PRIMARY KEY, "
                + "username VARCHAR(50) NOT NULL UNIQUE, "
                + "password_hash VARCHAR(255) NOT NULL, "
                + "full_name VARCHAR(100) NOT NULL, "
                + "email VARCHAR(100) NULL UNIQUE, "
                + "role VARCHAR(20) NOT NULL, "
                + "status VARCHAR(20) DEFAULT 'ACTIVE', "
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                + ")";

        String sqlDrivers = "CREATE TABLE IF NOT EXISTS drivers ("
                + "driver_id INT AUTO_INCREMENT PRIMARY KEY, "
                + "name VARCHAR(100) NOT NULL, "
                + "license_number VARCHAR(50) NOT NULL UNIQUE, "
                + "phone VARCHAR(20), "
                + "status VARCHAR(20) DEFAULT 'Available'"
                + ")";

        String sqlVehicles = "CREATE TABLE IF NOT EXISTS vehicles ("
                + "vehicle_id INT AUTO_INCREMENT PRIMARY KEY, "
                + "plate_number VARCHAR(20) NOT NULL UNIQUE, "
                + "vehicle_type VARCHAR(50) NOT NULL, "
                + "brand VARCHAR(50), "
                + "model VARCHAR(50), "
                + "capacity INT, "
                + "status VARCHAR(20) DEFAULT 'Available'"
                + ")";

        String sqlOrders = "CREATE TABLE IF NOT EXISTS delivery_orders ("
                + "order_id INT AUTO_INCREMENT PRIMARY KEY, "
                + "order_number VARCHAR(50) NOT NULL UNIQUE, "
                + "recipient_name VARCHAR(100) NOT NULL, "
                + "recipient_address TEXT NOT NULL, "
                + "contact_phone VARCHAR(50), "
                + "weight DOUBLE, "
                + "status VARCHAR(20) DEFAULT 'Pending', "
                + "driver_id INT NULL, "
                + "vehicle_id INT NULL, "
                + "FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE SET NULL, "
                + "FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE SET NULL"
                + ")";

        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sqlUsers);
            stmt.executeUpdate(sqlDrivers);
            stmt.executeUpdate(sqlVehicles);
            stmt.executeUpdate(sqlOrders);
            
            // Auto-migrate: ensure contact_phone column exists if table was created previously without it
            try {
                stmt.executeUpdate("ALTER TABLE delivery_orders ADD COLUMN contact_phone VARCHAR(50) AFTER recipient_address");
            } catch (SQLException ignored) {
                // Column already exists
            }
            
            seedDefaultAccounts(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void seedDefaultAccounts(Connection conn) {
        String countSql = "SELECT COUNT(*) FROM users";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(countSql)) {
            if (rs.next() && rs.getInt(1) == 0) {
                String adminHash = PasswordUtil.hashPassword("admin123");
                String insertAdmin = "INSERT INTO users (username, password_hash, full_name, email, role, status) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertAdmin)) {
                    ps.setString(1, "admin");
                    ps.setString(2, adminHash);
                    ps.setString(3, "System Administrator");
                    ps.setString(4, "admin@shopee.ph");
                    ps.setString(5, "ADMIN");
                    ps.setString(6, "ACTIVE");
                    ps.executeUpdate();
                }

                String supervisorHash = PasswordUtil.hashPassword("supervisor123");
                String insertSup = "INSERT INTO users (username, password_hash, full_name, email, role, status) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertSup)) {
                    ps.setString(1, "supervisor");
                    ps.setString(2, supervisorHash);
                    ps.setString(3, "Lead Operations Supervisor");
                    ps.setString(4, "supervisor@shopee.ph");
                    ps.setString(5, "SUPERVISOR");
                    ps.setString(6, "ACTIVE");
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        int id = rs.getInt("user_id");
        String username = rs.getString("username");
        String passHash = rs.getString("password_hash");
        String fullName = rs.getString("full_name");
        String email = rs.getString("email");
        String roleStr = rs.getString("role");
        String status = rs.getString("status");
        Timestamp createdAt = rs.getTimestamp("created_at");

        UserRole role = UserRole.fromString(roleStr);
        String createdStr = (createdAt != null) ? createdAt.toString() : "";

        return new User(id, username, passHash, fullName, email, role, status, createdStr);
    }

    public User findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) return null;
        String sql = "SELECT * FROM users WHERE LOWER(username) = LOWER(?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY user_id ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public synchronized boolean save(User user) {
        if (user == null) return false;
        String sql = "INSERT INTO users (username, password_hash, full_name, email, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getRole() != null ? user.getRole().name() : "SUPERVISOR");
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        user.setUserId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public synchronized boolean update(User user) {
        if (user == null || user.getUserId() <= 0) return false;
        String sql = "UPDATE users SET username = ?, password_hash = ?, full_name = ?, email = ?, role = ?, status = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getRole() != null ? user.getRole().name() : "SUPERVISOR");
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "ACTIVE");
            ps.setInt(7, user.getUserId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public synchronized boolean delete(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean usernameExists(String username) {
        return findByUsername(username) != null;
    }

    public boolean emailExists(String email) {
        return findByEmail(email) != null;
    }

    public User authenticate(String username, String rawPassword) {
        User user = findByUsername(username);
        if (user != null && user.isActive() && PasswordUtil.checkPassword(rawPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    public User registerUser(String username, String rawPassword, String fullName, String email, UserRole role) {
        String passHash = PasswordUtil.hashPassword(rawPassword);
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(passHash);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setRole(role != null ? role : UserRole.SUPERVISOR);
        user.setStatus("ACTIVE");
        if (save(user)) {
            return user;
        }
        return null;
    }

    public boolean updateUser(int userId, String fullName, String email, String status) {
        User user = findById(userId);
        if (user == null) return false;

        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
        }
        if (email != null && !email.trim().isEmpty()) {
            User existing = findByEmail(email.trim());
            if (existing != null && existing.getUserId() != userId) {
                return false;
            }
            user.setEmail(email.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            user.setStatus(status.trim());
        }
        return update(user);
    }
}
