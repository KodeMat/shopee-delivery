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
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(255, 255, 255, 0.02);
            --card-border: rgba(255, 255, 255, 0.08);
            --primary-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --text-accent: #fb923c;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --info-color: #3b82f6;
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        body {
            background-color: var(--bg-color);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            position: relative;
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
        .navbar {
            background: rgba(11, 15, 25, 0.8);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--card-border);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 100;
        }
        .navbar h2 {
            font-size: 1.4rem;
            font-weight: 700;
            background: linear-gradient(135deg, #ffffff 40%, #fdba74 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .nav-links a {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            margin-left: 20px;
            transition: color 0.2s;
        }
        .nav-links a:hover, .nav-links a.active {
            color: var(--text-accent);
        }
        .container {
            max-width: 1200px;
            width: 90%;
            margin: 40px auto;
            z-index: 10;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 24px;
            color: var(--text-accent);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .table-container {
            overflow-x: auto;
            margin-top: 16px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        th, td {
            padding: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        th {
            color: var(--text-secondary);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
        }
        td {
            font-size: 0.95rem;
        }
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .badge-pending {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.2);
            color: var(--warning-color);
        }
        .badge-assigned {
            background: rgba(59, 130, 246, 0.1);
            border: 1px solid rgba(59, 130, 246, 0.2);
            color: var(--info-color);
        }
        .badge-intransit {
            background: rgba(168, 85, 247, 0.1);
            border: 1px solid rgba(168, 85, 247, 0.2);
            color: #c084fc;
        }
        .badge-delivered {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: var(--success-color);
        }
        .badge-cancelled {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: var(--danger-color);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-secondary);
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }
        .form-input, select, textarea {
            width: 100%;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 12px;
            color: var(--text-primary);
            font-size: 0.95rem;
            outline: none;
            transition: all 0.3s;
        }
        .form-input:focus, select:focus, textarea:focus {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(249, 115, 22, 0.5);
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.15);
        }
        select option {
            background-color: var(--bg-color);
            color: var(--text-primary);
        }
        .btn-submit {
            display: block;
            width: 100%;
            background: var(--primary-glow);
            border: none;
            border-radius: 12px;
            padding: 12px;
            color: white;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 12px;
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.3);
        }
        .btn-clear {
            display: block;
            width: 100%;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 12px;
            color: var(--text-primary);
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-clear:hover {
            background: rgba(255, 255, 255, 0.06);
        }
        .alert {
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.9rem;
            margin-bottom: 20px;
            text-align: center;
        }
        .alert-error {
            background-color: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #f87171;
        }
        .alert-success {
            background-color: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #34d399;
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
                                            <!-- Change status form -->
                                            <form action="OrderServlet" method="post" class="status-container">
                                                <input type="hidden" name="action" value="setStatus">
                                                <input type="hidden" name="orderId" value="<%= orderId %>">
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

        <!-- Book Order panel -->
        <div class="glass-card">
            <h2 class="card-title">Book Delivery Order</h2>
            <form action="OrderServlet" method="post">
                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="orderNumber">Tracking/Order Number</label>
                    <input type="text" id="orderNumber" name="orderNumber" class="form-input" placeholder="e.g. SPX-98218-PH" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="recipientName">Recipient Name</label>
                    <input type="text" id="recipientName" name="recipientName" class="form-input" placeholder="e.g. Jane Smith" required autocomplete="off">
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
