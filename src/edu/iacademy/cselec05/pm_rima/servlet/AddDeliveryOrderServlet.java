package edu.iacademy.cselec05.pm_rima.servlet;

import edu.iacademy.cselec05.pm_rima.model.DeliveryOrder;
import edu.iacademy.cselec05.pm_rima.util.DatabaseConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/add-order")
public class AddDeliveryOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static final List<DeliveryOrder> orders = new ArrayList<>();

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

        request.setCharacterEncoding("UTF-8");
        String recipientName = request.getParameter("recipientName");
        String recipientAddress = request.getParameter("recipientAddress");
        String recipientPhone = request.getParameter("recipientPhone");
        double weight = 0.0;
        try {
            weight = Double.parseDouble(request.getParameter("weight"));
        } catch (Exception e) {
            weight = 0.0;
        }

        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        DeliveryOrder newOrder = new DeliveryOrder(orderId, recipientName, recipientAddress, recipientPhone, weight, "Pending");
        orders.add(newOrder);

        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "INSERT INTO delivery_orders (order_number, recipient_name, recipient_address, contact_phone, weight, status) VALUES (?, ?, ?, ?, ?, 'Pending')";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, orderId);
                ps.setString(2, recipientName);
                ps.setString(3, recipientAddress);
                ps.setString(4, recipientPhone);
                ps.setDouble(5, weight);
                ps.executeUpdate();
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
        response.sendRedirect(request.getContextPath() + "/orders.jsp");
    }
}
