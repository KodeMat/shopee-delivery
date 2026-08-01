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

public class OrderServlet extends HttpServlet {
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

        try (Connection conn = DatabaseConfig.getConnection()) {
            if ("add".equals(action)) {
                String orderNumber = request.getParameter("orderNumber");
                String recipientName = request.getParameter("recipientName");
                String recipientAddress = request.getParameter("recipientAddress");
                double weight = Double.parseDouble(request.getParameter("weight"));
                String sql = "INSERT INTO delivery_orders (order_number, recipient_name, recipient_address, weight, status) VALUES (?, ?, ?, ?, 'Pending')";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, orderNumber);
                    ps.setString(2, recipientName);
                    ps.setString(3, recipientAddress);
                    ps.setDouble(4, weight);
                    ps.executeUpdate();
                }
            } else if ("assign".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String driverIdStr = request.getParameter("driverId");
                String vehicleIdStr = request.getParameter("vehicleId");

                String sql = "UPDATE delivery_orders SET driver_id = ?, vehicle_id = ?, status = 'Assigned' WHERE order_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    if (driverIdStr == null || driverIdStr.isEmpty()) {
                        ps.setNull(1, java.sql.Types.INTEGER);
                    } else {
                        ps.setInt(1, Integer.parseInt(driverIdStr));
                    }

                    if (vehicleIdStr == null || vehicleIdStr.isEmpty()) {
                        ps.setNull(2, java.sql.Types.INTEGER);
                    } else {
                        ps.setInt(2, Integer.parseInt(vehicleIdStr));
                    }

                    ps.setInt(3, orderId);
                    ps.executeUpdate();
                }
            } else if ("setStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");

                String sql = "UPDATE delivery_orders SET status = ? WHERE order_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, status);
                    ps.setInt(2, orderId);
                    ps.executeUpdate();
                }
            }
            response.sendRedirect(request.getContextPath() + "/orders.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/orders.jsp?error=true");
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
        response.sendRedirect(request.getContextPath() + "/orders.jsp");
    }
}
