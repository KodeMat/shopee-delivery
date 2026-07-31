package edu.iacademy.cselec05.pm_rima;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("signup".equals(action)) {
            handleSignup(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp?logged_out=true");
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?")) {
            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    String status = rs.getString("status");

                    if ("UNREGISTERED".equals(status)) {
                        response.sendRedirect("login.jsp?error=pending");
                        return;
                    }

                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("user_id"));
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    if ("ADMIN".equals(role)) {
                        response.sendRedirect("admin_dashboard.jsp");
                    } else {
                        response.sendRedirect("supervisor_dashboard.jsp");
                    }
                } else {
                    response.sendRedirect("login.jsp?error=invalid");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=db");
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect("signup.jsp?error=empty");
            return;
        }

        try (Connection conn = DatabaseConfig.getConnection()) {
            // Check if username already exists
            try (PreparedStatement checkPs = conn.prepareStatement("SELECT 1 FROM users WHERE username = ?")) {
                checkPs.setString(1, username);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect("signup.jsp?error=exists");
                        return;
                    }
                }
            }

            try (PreparedStatement insertPs = conn.prepareStatement(
                    "INSERT INTO users (username, password, role, status) VALUES (?, ?, 'SUPERVISOR', 'UNREGISTERED')")) {
                insertPs.setString(1, username);
                insertPs.setString(2, password);
                insertPs.executeUpdate();
                response.sendRedirect("login.jsp?signup_success=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=db");
        }
    }
}
