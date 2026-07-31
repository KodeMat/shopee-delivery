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
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(255, 255, 255, 0.02);
            --card-border: rgba(255, 255, 255, 0.08);
            --primary-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --text-accent: #fb923c;
            --info-glow: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --success-glow: linear-gradient(135deg, #10b981 0%, #059669 100%);
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
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(249, 115, 22, 0.06) 0%, rgba(0,0,0,0) 70%);
            top: -150px;
            left: calc(50% - 300px);
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
        .nav-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .nav-info span {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        .btn-logout {
            color: #ef4444;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s;
        }
        .btn-logout:hover {
            opacity: 0.8;
        }
        .main-container {
            max-width: 1200px;
            width: 90%;
            margin: 40px auto;
            z-index: 10;
        }
        .welcome-section {
            margin-bottom: 32px;
        }
        .welcome-section h1 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .welcome-section p {
            color: var(--text-secondary);
            font-size: 1rem;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.15);
        }
        .stat-value {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .stat-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .accent-orange { color: #f97316; }
        .accent-blue { color: #3b82f6; }
        .accent-green { color: #10b981; }

        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
        }
        .module-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s;
        }
        .module-card:hover {
            transform: translateY(-4px);
            border-color: rgba(249, 115, 22, 0.25);
            box-shadow: 0 15px 35px rgba(249, 115, 22, 0.1);
        }
        .module-header h3 {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 12px;
            color: var(--text-primary);
        }
        .module-header p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.5;
            margin-bottom: 24px;
        }
        .module-links {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .module-btn {
            display: block;
            text-align: center;
            padding: 12px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s;
        }
        .btn-primary {
            background: var(--primary-glow);
            color: white;
            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
        }
        .btn-primary:hover {
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.35);
        }
        .btn-secondary {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            color: var(--text-primary);
        }
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(255, 255, 255, 0.15);
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Parcel Delivery Terminal</h2>
        <div class="nav-info">
            <span>Logged in as: <strong><%= username %></strong> (<%= role %>)</span>
            <a href="AuthServlet?action=logout" class="btn-logout">Logout</a>
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
