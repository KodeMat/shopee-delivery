<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.model.User" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.model.UserRole" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");
    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);
    boolean isSupervisor = "SUPERVISOR".equalsIgnoreCase(role);
    boolean justRegistered = "true".equals(request.getParameter("registered"));
    String newUsername = request.getParameter("newUsername");
    boolean justUpdated = "true".equals(request.getParameter("updated"));
    String updatedUsername = request.getParameter("updatedUser");

    List<User> supervisors = new ArrayList<>();
    if (isAdmin) {
        for (User u : UserDAO.getInstance().findAll()) {
            if (u.getRole() == UserRole.SUPERVISOR) {
                supervisors.add(u);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(255, 255, 255, 0.025);
            --card-border: rgba(255, 255, 255, 0.08);
            --primary-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --text-accent: #fb923c;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --success-bg: rgba(16, 185, 129, 0.1);
            --success-border: rgba(16, 185, 129, 0.2);
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
            left: -100px;
            z-index: 0;
            pointer-events: none;
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
        .nav-right {
            display: flex;
            align-items: center;
            gap: 16px;
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
        .role-tag {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .role-tag.admin {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }
        .role-tag.supervisor {
            background: rgba(59, 130, 246, 0.1);
            color: #93c5fd;
            border: 1px solid rgba(59, 130, 246, 0.2);
        }
        .btn-logout {
            padding: 8px 16px;
            font-size: 0.9rem;
            font-weight: 500;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--card-border);
            border-radius: 8px;
            color: var(--text-secondary);
            cursor: pointer;
            text-decoration: none;
            transition: background 0.15s ease;
        }
        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.08);
            color: var(--text-primary);
        }
        .main-container {
            max-width: 1200px;
            width: 90%;
            margin: 40px auto;
            z-index: 10;
        }
        .welcome-header {
            margin-bottom: 32px;
        }
        .welcome-header h1 {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #ffffff 0%, #9ca3af 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .welcome-header p {
            font-size: 14px;
            color: var(--text-secondary);
        }
        .alert-success {
            background: var(--success-bg);
            border: 1px solid var(--success-border);
            border-radius: 12px;
            padding: 14px 20px;
            font-size: 14px;
            color: #6ee7b7;
            margin-bottom: 24px;
        }
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            margin-bottom: 32px;
        }
        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-accent);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .btn-primary {
            display: inline-block;
            padding: 10px 20px;
            font-size: 0.9rem;
            font-weight: 600;
            background: var(--primary-glow);
            border: none;
            border-radius: 10px;
            color: #ffffff;
            cursor: pointer;
            text-decoration: none;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
            box-shadow: 0 4px 14px rgba(249, 115, 22, 0.3);
        }
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.4);
        }
        .table-container {
            overflow-x: auto;
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
        .edit-link {
            color: var(--text-accent);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
        }
        .edit-link:hover {
            text-decoration: underline;
        }
        .status-active {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: var(--success-color);
        }
        .status-inactive {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: var(--danger-color);
        }
        .empty-state {
            padding: 40px 20px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 14px;
        }
        .supervisor-dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        .module-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 28px;
            transition: border-color 0.2s ease, transform 0.2s ease;
        }
        .module-card:hover {
            border-color: rgba(249, 115, 22, 0.3);
            transform: translateY(-2px);
        }
        .module-card h3 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 8px;
        }
        .module-card p {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 20px;
            line-height: 1.5;
        }
        .footer {
            text-align: center;
            font-size: 12px;
            color: var(--text-secondary);
            padding: 24px 0;
            margin-top: auto;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Shopee Delivery Logistics</h2>
        <div class="nav-right">
            <div class="nav-links">
                <a href="index.jsp" class="active">Dashboard</a>
                <% if (isSupervisor) { %>
                    <a href="driver.jsp">Drivers</a>
                    <a href="vehicle.jsp">Vehicles</a>
                    <a href="orders.jsp">Orders</a>
                <% } %>
            </div>
            <span class="role-tag <%= isAdmin ? "admin" : "supervisor" %>"><%= role %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Sign Out</a>
        </div>
    </div>

    <div class="main-container">
        <% if (justRegistered) { %>
            <div class="alert-success">
                Supervisor account <strong><%= newUsername != null ? newUsername : "" %></strong> has been created.
            </div>
        <% } %>
        <% if (justUpdated) { %>
            <div class="alert-success">
                Supervisor <strong><%= updatedUsername != null ? updatedUsername : "" %></strong> has been updated.
            </div>
        <% } %>

        <div class="welcome-header">
            <h1>Welcome back, <%= fullName %></h1>
            <p>Signed in as <%= role.toLowerCase() %> &middot; <%= currentUser.getUsername() %></p>
        </div>

        <% if (isAdmin) { %>
            <div class="glass-card">
                <div class="card-header">
                    <h2 class="card-title">Supervisor Management</h2>
                    <a href="<%= request.getContextPath() %>/register" class="btn-primary">+ Register Supervisor</a>
                </div>
                <div class="table-container">
                    <% if (supervisors.isEmpty()) { %>
                        <div class="empty-state">No supervisor accounts registered yet.</div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Created</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User sup : supervisors) { %>
                                    <tr>
                                        <td><%= sup.getUserId() %></td>
                                        <td><strong><%= sup.getUsername() %></strong></td>
                                        <td><%= sup.getFullName() %></td>
                                        <td><%= sup.getEmail() %></td>
                                        <td>
                                            <% if (sup.isActive()) { %>
                                                <span class="status-active">Active</span>
                                            <% } else { %>
                                                <span class="status-inactive">Inactive</span>
                                            <% } %>
                                        </td>
                                        <td><%= sup.getCreatedAt() %></td>
                                        <td><a href="<%= request.getContextPath() %>/edit-user?id=<%= sup.getUserId() %>" class="edit-link">Edit</a></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        <% } %>

        <% if (isSupervisor) { %>
            <div class="supervisor-dashboard-grid">
                <div class="module-card">
                    <h3>Driver Management</h3>
                    <p>Manage fleet drivers, license numbers, phone contacts, and operational availability.</p>
                    <a href="driver.jsp" class="btn-primary">Manage Drivers &rarr;</a>
                </div>
                <div class="module-card">
                    <h3>Fleet Vehicles</h3>
                    <p>Track delivery motorcycles, vans, trucks, load capacities, and maintenance schedules.</p>
                    <a href="vehicle.jsp" class="btn-primary">Manage Vehicles &rarr;</a>
                </div>
                <div class="module-card">
                    <h3>Delivery Orders</h3>
                    <p>Create shipments, assign drivers & vehicles, and update real-time delivery tracking status.</p>
                    <a href="orders.jsp" class="btn-primary">Manage Orders &rarr;</a>
                </div>
            </div>
        <% } %>

        <div class="footer">
            Shopee Delivery System v1.0 &middot; Server Time: <%= new java.util.Date() %>
        </div>
    </div>
</body>
</html>
