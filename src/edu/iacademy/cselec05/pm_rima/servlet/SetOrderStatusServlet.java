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

@WebServlet("/set-status")
public class SetOrderStatusServlet extends HttpServlet {
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

        request.setCharacterEncoding("UTF-8");
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        // Update in-memory list (Denise's logic)
        for (DeliveryOrder order : AddDeliveryOrderServlet.orders) {
            if (order.getId() != null && order.getId().equalsIgnoreCase(orderId)) {
                order.setStatus(newStatus);
                break;
            }
        }

        // Update MySQL database
        try (Connection conn = DatabaseConfig.getConnection()) {
            String sql = "UPDATE delivery_orders SET status = ? WHERE order_number = ? OR order_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setString(2, orderId);
                int numericId = 0;
                try {
                    numericId = Integer.parseInt(orderId);
                } catch (Exception ignored) {}
                ps.setInt(3, numericId);
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
