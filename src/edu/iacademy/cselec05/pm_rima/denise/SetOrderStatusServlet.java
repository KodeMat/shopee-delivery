package edu.iacademy.cselec05.pm_rima.denise;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/set-status")
public class SetOrderStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        DeliveryOrder foundOrder = null;
        for (DeliveryOrder order : AddDeliveryOrderServlet.orders) {
            if (order.getId().equalsIgnoreCase(orderId)) {
                foundOrder = order;
                break;
            }
        }

        if (foundOrder != null) {
            foundOrder.setStatus(newStatus);
            request.setAttribute("message", "Status for order " + orderId + " updated to: " + newStatus);
        } else {
            request.setAttribute("error", "Order ID not found!");
        }

        request.getRequestDispatcher("set-status.jsp").forward(request, response);
    }
}