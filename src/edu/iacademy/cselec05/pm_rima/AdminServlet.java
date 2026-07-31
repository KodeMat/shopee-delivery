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

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            try (Connection conn = DatabaseConfig.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE users SET status = 'APPROVED' WHERE user_id = ? AND role = 'SUPERVISOR'")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                response.sendRedirect("admin_dashboard.jsp?success=approved");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?error=db");
            }
        } else if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                response.sendRedirect("admin_dashboard.jsp?error=empty");
                return;
            }

            try (Connection conn = DatabaseConfig.getConnection()) {
                // Check if username already exists
                try (PreparedStatement checkPs = conn.prepareStatement("SELECT 1 FROM users WHERE username = ?")) {
                    checkPs.setString(1, username);
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (rs.next()) {
                            response.sendRedirect("admin_dashboard.jsp?error=exists");
                            return;
                        }
                    }
                }

                try (PreparedStatement insertPs = conn.prepareStatement(
                        "INSERT INTO users (username, password, role, status) VALUES (?, ?, 'SUPERVISOR', 'APPROVED')")) {
                    insertPs.setString(1, username);
                    insertPs.setString(2, password);
                    insertPs.executeUpdate();
                    response.sendRedirect("admin_dashboard.jsp?success=registered");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_dashboard.jsp?error=db");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        response.sendRedirect("admin_dashboard.jsp");
    }
}
