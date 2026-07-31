package edu.iacademy.cselec05.pm_rima;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/add-order")
public class AddDeliveryOrderServlet extends HttpServlet {

    public static final List<DeliveryOrder> orders = new ArrayList<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String recipientName = request.getParameter("recipientName");
        String recipientAddress = request.getParameter("recipientAddress");
        String recipientPhone = request.getParameter("recipientPhone");
        double weight = Double.parseDouble(request.getParameter("weight"));

        String orderId = "ORD-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase();

        DeliveryOrder newOrder = new DeliveryOrder(orderId, recipientName, recipientAddress, recipientPhone, weight, "Pending");
        orders.add(newOrder);

        request.setAttribute("message", "Delivery Order " + orderId + " created successfully!");
        request.getRequestDispatcher("add-order.jsp").forward(request, response);
    }
}