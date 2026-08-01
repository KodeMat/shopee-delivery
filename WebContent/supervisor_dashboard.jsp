<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.DatabaseConfig" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) sess.getAttribute("username");
    String role = (String) sess.getAttribute("role");

    int driverCount = 0;
    int vehicleCount = 0;
    int pendingOrders = 0;
    int transitOrders = 0;
    int deliveredOrders = 0;

    try (Connection conn = DatabaseConfig.getConnection()) {
        // Driver stats
        try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT count(*) FROM drivers")) {
            if (rs.next()) driverCount = rs.getInt(1);
        }
        // Vehicle stats
        try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT count(*) FROM vehicles")) {
            if (rs.next()) vehicleCount = rs.getInt(1);
        }
        // Pending order stats
        try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT count(*) FROM delivery_orders WHERE status = 'Pending' OR status = 'Assigned'")) {
            if (rs.next()) pendingOrders = rs.getInt(1);
        }
        // In transit
        try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT count(*) FROM delivery_orders WHERE status = 'In Transit'")) {
            if (rs.next()) transitOrders = rs.getInt(1);
        }
        // Delivered
        try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT count(*) FROM delivery_orders WHERE status = 'Delivered'")) {
            if (rs.next()) deliveredOrders = rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supervisor Dashboard - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/common.css?v=2">
</head>
<body>
    <div class="navbar">
        <h2>Shopee Delivery Logistics</h2>
        <div class="nav-right">
            <div class="nav-links">
                <a href="index.jsp" class="active">Dashboard</a>
                <a href="driver.jsp">Drivers</a>
                <a href="vehicle.jsp">Vehicles</a>
                <a href="orders.jsp">Orders</a>
            </div>
            <span class="role-tag supervisor"><%= role %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Sign Out</a>
        </div>
    </div>

    <div class="main-container">
        <div class="welcome-section">
            <h1>Welcome Back!</h1>
            <p>Logistics Control Center &bull; Live operational metrics and module hubs.</p>
        </div>

        <!-- Live Metrics Section -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value accent-orange"><%= driverCount %></div>
                <div class="stat-label">Active Drivers</div>
            </div>
            <div class="stat-card">
                <div class="stat-value accent-blue"><%= vehicleCount %></div>
                <div class="stat-label">Registered Fleet</div>
            </div>
            <div class="stat-card">
                <div class="stat-value accent-orange"><%= pendingOrders %></div>
                <div class="stat-label">Unfulfilled Orders</div>
            </div>
            <div class="stat-card">
                <div class="stat-value accent-blue"><%= transitOrders %></div>
                <div class="stat-label">In Transit</div>
            </div>
            <div class="stat-card">
                <div class="stat-value accent-green"><%= deliveredOrders %></div>
                <div class="stat-label">Delivered Today</div>
            </div>
        </div>

        <!-- Modules Grid -->
        <div class="modules-grid">
            <!-- Driver Module -->
            <div class="module-card">
                <div class="module-header">
                    <h3>Driver Management</h3>
                    <p>Register new dispatch drivers, check licenses, track availability states, and edit employee directories.</p>
                </div>
                <div class="module-links">
                    <a href="driver.jsp" class="module-btn btn-primary">Open Driver Hub</a>
                </div>
            </div>

            <!-- Vehicle Module -->
            <div class="module-card">
                <div class="module-header">
                    <h3>Vehicle Fleet</h3>
                    <p>Manage transport assets including vans, heavy trucks, and motorcycles. Update capacity metrics and maintenance flags.</p>
                </div>
                <div class="module-links">
                    <a href="vehicle.jsp" class="module-btn btn-primary">Open Vehicle Fleet</a>
                </div>
            </div>

            <!-- Orders Module -->
            <div class="module-card">
                <div class="module-header">
                    <h3>Delivery Orders</h3>
                    <p>Book new cargo parcels, assign active drivers & vehicles to delivery batches, and perform status updates.</p>
                </div>
                <div class="module-links">
                    <a href="orders.jsp" class="module-btn btn-primary">Manage Delivery Orders</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
