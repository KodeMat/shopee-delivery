package edu.iacademy.cselec05.pm_rima.dao;

import edu.iacademy.cselec05.pm_rima.model.User;
import edu.iacademy.cselec05.pm_rima.model.UserRole;
import edu.iacademy.cselec05.pm_rima.util.PasswordUtil;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class UserDAO {

    private static final UserDAO INSTANCE = new UserDAO();
    private final Map<Integer, User> userMap = new ConcurrentHashMap<>();
    private final AtomicInteger idSequence = new AtomicInteger(100);
    private final File dataFile;

    private UserDAO() {
        String baseDir = System.getProperty("catalina.base");
        if (baseDir == null || baseDir.trim().isEmpty()) {
            baseDir = System.getProperty("user.dir");
        }
        File storeDir = new File(baseDir, "data");
        if (!storeDir.exists()) {
            storeDir.mkdirs();
        }
        this.dataFile = new File(storeDir, "users_store.dat");

        loadUsersFromFile();

        // Seed initial default accounts if empty
        if (userMap.isEmpty()) {
            seedDefaultAccounts();
        }
    }

    public static UserDAO getInstance() {
        return INSTANCE;
    }

    private void seedDefaultAccounts() {
        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

        User admin = new User(
            idSequence.incrementAndGet(),
            "admin",
            PasswordUtil.hashPassword("admin123"),
            "System Administrator",
            "admin@shopeedelivery.com",
            UserRole.ADMIN,
            "ACTIVE",
            now
        );
        userMap.put(admin.getUserId(), admin);

        User supervisor = new User(
            idSequence.incrementAndGet(),
            "supervisor",
            PasswordUtil.hashPassword("supervisor123"),
            "Operations Supervisor",
            "supervisor@shopeedelivery.com",
            UserRole.SUPERVISOR,
            "ACTIVE",
            now
        );
        userMap.put(supervisor.getUserId(), supervisor);

        saveUsersToFile();
    }

    public User findByUsername(String username) {
        if (username == null) return null;
        for (User user : userMap.values()) {
            if (user.getUsername().equalsIgnoreCase(username.trim())) {
                return user;
            }
        }
        return null;
    }

    public User findByEmail(String email) {
        if (email == null) return null;
        for (User user : userMap.values()) {
            if (user.getEmail().equalsIgnoreCase(email.trim())) {
                return user;
            }
        }
        return null;
    }

    public User findById(int userId) {
        return userMap.get(userId);
    }

    public List<User> findAll() {
        List<User> list = new ArrayList<>(userMap.values());
        list.sort(Comparator.comparingInt(User::getUserId));
        return list;
    }

    public synchronized User registerUser(String username, String rawPassword, String fullName, String email, UserRole role) {
        if (findByUsername(username) != null || findByEmail(email) != null) {
            return null; // Duplicate
        }

        int newId = idSequence.incrementAndGet();
        String hashedPassword = PasswordUtil.hashPassword(rawPassword);
        String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        UserRole assignedRole = (role != null) ? role : UserRole.SUPERVISOR;

        User newUser = new User(newId, username.trim(), hashedPassword, fullName.trim(), email.trim(), assignedRole, "ACTIVE", now);
        userMap.put(newId, newUser);
        saveUsersToFile();
        return newUser;
    }

    public synchronized boolean updateUser(int userId, String fullName, String email, String status) {
        User user = userMap.get(userId);
        if (user == null) {
            return false;
        }
        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
        }
        if (email != null && !email.trim().isEmpty()) {
            // Check uniqueness against other users
            User existing = findByEmail(email.trim());
            if (existing != null && existing.getUserId() != userId) {
                return false;
            }
            user.setEmail(email.trim());
        }
        if (status != null) {
            user.setStatus(status.trim().toUpperCase());
        }
        saveUsersToFile();
        return true;
    }

    public User authenticate(String username, String rawPassword) {
        User user = findByUsername(username);
        if (user == null || !user.isActive()) {
            return null;
        }
        if (PasswordUtil.verifyPassword(rawPassword, user.getPasswordHash())) {
            return user;
        }
        return null;
    }

    private synchronized void saveUsersToFile() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(dataFile))) {
            List<User> list = new ArrayList<>(userMap.values());
            oos.writeObject(list);
            oos.writeInt(idSequence.get());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings("unchecked")
    private synchronized void loadUsersFromFile() {
        if (!dataFile.exists() || dataFile.length() == 0) {
            return;
        }
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(dataFile))) {
            List<User> list = (List<User>) ois.readObject();
            int maxId = idSequence.get();
            for (User u : list) {
                userMap.put(u.getUserId(), u);
                if (u.getUserId() > maxId) {
                    maxId = u.getUserId();
                }
            }
            if (ois.available() > 0) {
                maxId = ois.readInt();
            }
            idSequence.set(maxId);
        } catch (Exception e) {
            // Log & reset map if corrupted
            userMap.clear();
        }
    }
}
