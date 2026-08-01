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
    <link rel="stylesheet" href="css/common.css?v=2">
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
