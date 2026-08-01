package edu.iacademy.cselec05.pm_rima.servlet;

import edu.iacademy.cselec05.pm_rima.util.DatabaseConfig;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class VehicleServlet extends HttpServlet {
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
        String plateNumber = request.getParameter("plateNumber");
        String vehicleType = request.getParameter("vehicleType");
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String status = request.getParameter("status");

        int capacity = 0;
        try {
            capacity = Integer.parseInt(request.getParameter("capacity"));
        } catch (Exception e) {
            capacity = 0;
        }

        try (Connection con = DatabaseConfig.getConnection()) {
            if ("add".equals(action)) {
                String sql = "INSERT INTO vehicles (plate_number, vehicle_type, brand, model, capacity, status) VALUES (?,?,?,?,?,?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, plateNumber);
                    ps.setString(2, vehicleType);
                    ps.setString(3, brand);
                    ps.setString(4, model);
                    ps.setInt(5, capacity);
                    ps.setString(6, status != null ? status : "Available");
                    ps.executeUpdate();
                }
            } else if ("edit".equals(action)) {
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                String sql = "UPDATE vehicles SET plate_number=?, vehicle_type=?, brand=?, model=?, capacity=?, status=? WHERE vehicle_id=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, plateNumber);
                    ps.setString(2, vehicleType);
                    ps.setString(3, brand);
                    ps.setString(4, model);
                    ps.setInt(5, capacity);
                    ps.setString(6, status);
                    ps.setInt(7, vehicleId);
                    ps.executeUpdate();
                }
            }
            response.sendRedirect(request.getContextPath() + "/vehicle.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/vehicle.jsp?error=true");
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
            try (Connection con = DatabaseConfig.getConnection()) {
                int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
                String sql = "DELETE FROM vehicles WHERE vehicle_id=?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, vehicleId);
                    ps.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/vehicle.jsp?success=true");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/vehicle.jsp?error=true");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/vehicle.jsp");
    }
}
