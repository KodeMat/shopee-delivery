package edu.iacademy.cselec05.pm_rima.servlet;

import edu.iacademy.cselec05.pm_rima.dao.UserDAO;
import edu.iacademy.cselec05.pm_rima.model.User;
import edu.iacademy.cselec05.pm_rima.model.UserRole;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) {
            return;
        }
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) {
            return;
        }
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String roleParam = request.getParameter("role");

        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);

        if (isEmpty(username) || isEmpty(fullName) || isEmpty(email) || isEmpty(password) || isEmpty(confirmPassword)) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        fullName = fullName.trim();
        email = email.trim();

        if (username.length() < 3 || username.length() > 30) {
            request.setAttribute("errorMessage", "Username must be between 3 and 30 characters.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorMessage", "Please enter a valid email address.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = UserDAO.getInstance();

        if (userDAO.findByUsername(username) != null) {
            request.setAttribute("errorMessage", "Username '" + username + "' is already taken.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.findByEmail(email) != null) {
            request.setAttribute("errorMessage", "Email address '" + email + "' is already registered.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        UserRole targetRole = UserRole.fromString(roleParam);
        User newUser = userDAO.registerUser(username, password, fullName, email, targetRole);

        if (newUser != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?registered=true&newUsername=" + username);
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a system error. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
