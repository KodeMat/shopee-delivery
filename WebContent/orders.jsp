<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.util.DatabaseConfig" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = (String) sess.getAttribute("role");
    if (!"SUPERVISOR".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String username = (String) sess.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Orders - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/common.css">
    <style>
        body {
            display: flex;
            flex-direction: column;
        }
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(249, 115, 22, 0.06) 0%, rgba(0,0,0,0) 70%);
            top: -150px;
            left: -100px;
            z-index: 0;
        }
        .inline-form {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .inline-form select {
            padding: 6px 10px;
            font-size: 0.85rem;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Delivery Orders</h2>
        <div class="nav-links">
            <a href="index.jsp">Dashboard</a>
            <a href="driver.jsp">Drivers</a>
            <a href="vehicle.jsp">Vehicles</a>
            <a href="orders.jsp" class="active">Orders</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <!-- Order List & Assignment panel -->
        <div class="glass-card">
            <h2 class="card-title">Order Catalog & Fleet Assignment</h2>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");

                if ("true".equals(success)) {
            %>
                <div class="alert alert-success">Order operation executed successfully!</div>
            <%
                } else if ("true".equals(error)) {
            %>
                <div class="alert alert-error">Something went wrong. Please check your data.</div>
            <%
                }
            %>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Order details</th>
                            <th>Cargo Weight</th>
                            <th>Status</th>
                            <th>Assigned Dispatch</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DatabaseConfig.getConnection();
                                 PreparedStatement ps = conn.prepareStatement(
                                     "SELECT o.*, d.name AS driver_name, v.plate_number, v.vehicle_type " +
                                     "FROM delivery_orders o " +
                                     "LEFT JOIN drivers d ON o.driver_id = d.driver_id " +
                                     "LEFT JOIN vehicles v ON o.vehicle_id = v.vehicle_id");
                                 ResultSet rs = ps.executeQuery()) {
                                
                                boolean hasOrders = false;
                                while (rs.next()) {
                                    hasOrders = true;
                                    int orderId = rs.getInt("order_id");
                                    String orderNum = rs.getString("order_number");
                                    String recName = rs.getString("recipient_name");
                                    String recAddr = rs.getString("recipient_address");
                                    double weight = rs.getDouble("weight");
                                    String stat = rs.getString("status");
                                    
                                    String badgeClass = "badge-pending";
                                    if ("Assigned".equals(stat)) badgeClass = "badge-assigned";
                                    else if ("In Transit".equals(stat)) badgeClass = "badge-transit";
                                    else if ("Delivered".equals(stat)) badgeClass = "badge-delivered";
                                    else if ("Cancelled".equals(stat)) badgeClass = "badge-cancelled";

                                    String driverName = rs.getString("driver_name");
                                    String vehiclePlate = rs.getString("plate_number");
                                    String vehicleType = rs.getString("vehicle_type");
                        %>
                                    <tr>
                                        <td>
                                            <strong>#<%= orderNum %></strong><br>
                                            <span style="font-size: 0.85rem; color: var(--text-secondary);">
                                                To: <%= recName %><br>
                                                Addr: <%= recAddr %>
                                            </span>
                                        </td>
                                        <td><%= weight %> kg</td>
                                        <td>
                                            <span class="badge <%= badgeClass %>"><%= stat %></span>
                                        </td>
                                        <td>
                                            <% if (driverName != null) { %>
                                                <div style="font-size: 0.85rem; line-height: 1.4;">
                                                    👤 <%= driverName %><br>
                                                    🚚 <%= vehiclePlate %> (<%= vehicleType %>)
                                                </div>
                                            <% } else { %>
                                                <span style="color: var(--text-secondary); font-size: 0.85rem; font-style: italic;">Unassigned</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <!-- Change status form (Denise's SetOrderStatusServlet) -->
                                            <form action="set-status" method="post" class="status-container">
                                                <input type="hidden" name="orderId" value="<%= orderNum %>">
                                                <select name="status" class="small-select">
                                                    <option value="Pending" <%= "Pending".equals(stat) ? "selected" : "" %>>Pending</option>
                                                    <option value="Assigned" <%= "Assigned".equals(stat) ? "selected" : "" %>>Assigned</option>
                                                    <option value="In Transit" <%= "In Transit".equals(stat) ? "selected" : "" %>>In Transit</option>
                                                    <option value="Delivered" <%= "Delivered".equals(stat) ? "selected" : "" %>>Delivered</option>
                                                    <option value="Cancelled" <%= "Cancelled".equals(stat) ? "selected" : "" %>>Cancelled</option>
                                                </select>
                                                <button type="submit" class="btn-inline">Set Status</button>
                                            </form>

                                            <!-- Assign Driver/Vehicle form -->
                                            <form action="OrderServlet" method="post" class="assign-container">
                                                <input type="hidden" name="action" value="assign">
                                                <input type="hidden" name="orderId" value="<%= orderId %>">
                                                
                                                <select name="driverId" class="small-select">
                                                    <option value="">-- Choose Driver --</option>
                                                    <%
                                                        // Fetch available drivers
                                                        try (PreparedStatement psDrv = conn.prepareStatement("SELECT * FROM drivers WHERE status = 'Available'");
                                                             ResultSet rsDrv = psDrv.executeQuery()) {
                                                            while (rsDrv.next()) {
                                                                int drvId = rsDrv.getInt("driver_id");
                                                                String drvName = rsDrv.getString("name");
                                                                boolean isSel = drvId == rs.getInt("driver_id");
                                                    %>
                                                                <option value="<%= drvId %>" <%= isSel ? "selected" : "" %>><%= drvName %></option>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </select>

                                                <select name="vehicleId" class="small-select">
                                                    <option value="">-- Choose Vehicle --</option>
                                                    <%
                                                        // Fetch available vehicles
                                                        try (PreparedStatement psVeh = conn.prepareStatement("SELECT * FROM vehicles WHERE status = 'Available'");
                                                             ResultSet rsVeh = psVeh.executeQuery()) {
                                                            while (rsVeh.next()) {
                                                                int vehId = rsVeh.getInt("vehicle_id");
                                                                String vehPlate = rsVeh.getString("plate_number");
                                                                String vehType = rsVeh.getString("vehicle_type");
                                                                boolean isSel = vehId == rs.getInt("vehicle_id");
                                                    %>
                                                                <option value="<%= vehId %>" <%= isSel ? "selected" : "" %>><%= vehPlate %> (<%= vehType %>)</option>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </select>

                                                <button type="submit" class="btn-inline">Assign Fleet</button>
                                            </form>
                                        </td>
                                    </tr>
                        <%
                                }
                                if (!hasOrders) {
                        %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-secondary); padding: 32px 0;">No delivery orders booked yet.</td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="5" style="color: var(--danger-color); text-align: center;">Error retrieving orders database.</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Book Order panel (Denise's AddDeliveryOrderServlet) -->
        <div class="glass-card">
            <h2 class="card-title">Book Delivery Order</h2>
            <form action="add-order" method="post">
                <div class="form-group">
                    <label for="recipientName">Recipient Name</label>
                    <input type="text" id="recipientName" name="recipientName" class="form-input" placeholder="e.g. Jane Smith" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="recipientPhone">Contact Phone</label>
                    <input type="text" id="recipientPhone" name="recipientPhone" class="form-input" placeholder="e.g. +63 917 123 4567" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="recipientAddress">Recipient Address</label>
                    <input type="text" id="recipientAddress" name="recipientAddress" class="form-input" placeholder="e.g. 123 Main St, Manila" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="weight">Weight (kg)</label>
                    <input type="number" step="0.01" id="weight" name="weight" class="form-input" placeholder="e.g. 2.5" required autocomplete="off">
                </div>

                <button type="submit" class="btn-submit">Book Order</button>
            </form>
        </div>
    </div>
</body>
</html>
