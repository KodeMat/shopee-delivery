package edu.iacademy.cselec05.pm_rima.servlet;

import edu.iacademy.cselec05.pm_rima.util.DatabaseConfig;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"SUPERVISOR".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String licenseNumber = request.getParameter("licenseNumber");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        try (Connection conn = DatabaseConfig.getConnection()) {
            if ("add".equals(action)) {
                String sql = "INSERT INTO drivers (name, license_number, phone, status) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setString(2, licenseNumber);
                    ps.setString(3, phone);
                    ps.setString(4, status != null ? status : "Available");
                    ps.executeUpdate();
                }
            } else if ("edit".equals(action)) {
                int driverId = Integer.parseInt(request.getParameter("driverId"));
                String sql = "UPDATE drivers SET name = ?, license_number = ?, phone = ?, status = ? WHERE driver_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, name);
                    ps.setString(2, licenseNumber);
                    ps.setString(3, phone);
                    ps.setString(4, status);
                    ps.setInt(5, driverId);
                    ps.executeUpdate();
                }
            }
            response.sendRedirect(request.getContextPath() + "/driver.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/driver.jsp?error=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"SUPERVISOR".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try (Connection conn = DatabaseConfig.getConnection()) {
                int driverId = Integer.parseInt(request.getParameter("driverId"));
                String sql = "DELETE FROM drivers WHERE driver_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, driverId);
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/driver.jsp?success=true");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/driver.jsp?error=true");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/driver.jsp");
    }
}
