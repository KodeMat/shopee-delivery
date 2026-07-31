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
    <title>Dashboard - Shopee Delivery System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f5f5f5;
            color: #333;
            min-height: 100vh;
        }

        .topbar {
            background: #fff;
            border-bottom: 1px solid #e5e5e5;
            padding: 0 24px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .topbar-brand {
            font-size: 16px;
            font-weight: 700;
            color: #ee4d2d;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13px;
        }

        .user-info { color: #555; }
        .user-info strong { color: #222; }

        .role-tag {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .role-tag.admin {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .role-tag.supervisor {
            background: #eff6ff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
        }

        .btn-logout {
            padding: 6px 14px;
            font-size: 13px;
            font-family: inherit;
            font-weight: 500;
            background: #fff;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            color: #555;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-logout:hover { background: #f9f9f9; }

        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 24px;
        }

        .welcome-section {
            margin-bottom: 24px;
        }

        .welcome-section h1 {
            font-size: 22px;
            font-weight: 700;
            color: #222;
            margin-bottom: 4px;
        }

        .welcome-section p {
            font-size: 14px;
            color: #888;
        }

        .alert-success {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            color: #15803d;
            margin-bottom: 20px;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .section-label {
            font-size: 12px;
            font-weight: 600;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            display: inline-block;
            padding: 8px 16px;
            font-size: 13px;
            font-family: inherit;
            font-weight: 600;
            background: #ee4d2d;
            border: none;
            border-radius: 6px;
            color: #fff;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.15s;
        }

        .btn-primary:hover { background: #d63e1f; }

        .table-card {
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            overflow: hidden;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            text-align: left;
            padding: 10px 16px;
            font-size: 11px;
            font-weight: 600;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #fafafa;
            border-bottom: 1px solid #e5e5e5;
        }

        .data-table td {
            padding: 12px 16px;
            font-size: 13px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .data-table tr:hover td {
            background: #fafafa;
        }

        .edit-link {
            color: #ee4d2d;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
        }

        .edit-link:hover {
            text-decoration: underline;
        }

        .status-active {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
            background: #f0fdf4;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .status-inactive {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .empty-state {
            padding: 40px 20px;
            text-align: center;
            color: #aaa;
            font-size: 14px;
        }

        .supervisor-welcome {
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            padding: 32px 24px;
            text-align: center;
        }

        .supervisor-welcome h2 {
            font-size: 18px;
            font-weight: 600;
            color: #222;
            margin-bottom: 8px;
        }

        .supervisor-welcome p {
            font-size: 14px;
            color: #888;
            line-height: 1.5;
        }

        .footer {
            text-align: center;
            font-size: 12px;
            color: #bbb;
            padding: 24px 0;
        }
    </style>
</head>
<body>
    <div class="topbar">
        <span class="topbar-brand">Shopee Delivery</span>
        <div class="topbar-right">
            <span class="user-info">
                <strong><%= fullName %></strong>
                <span class="role-tag <%= isAdmin ? "admin" : "supervisor" %>"><%= role %></span>
            </span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Sign Out</a>
        </div>
    </div>

    <div class="main-content">
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

        <div class="welcome-section">
            <h1>Welcome, <%= fullName %></h1>
            <p>Signed in as <%= role.toLowerCase() %> &middot; <%= currentUser.getUsername() %></p>
        </div>

        <% if (isAdmin) { %>
            <div class="section-header">
                <span class="section-label">Supervisor Accounts</span>
                <a href="<%= request.getContextPath() %>/register" class="btn-primary">+ Register Supervisor</a>
            </div>
            <div class="table-card">
                <% if (supervisors.isEmpty()) { %>
                    <div class="empty-state">No supervisor accounts registered yet.</div>
                <% } else { %>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th></th>
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
        <% } else if (isSupervisor) { %>
            <div class="supervisor-welcome">
                <h2>Supervisor Dashboard</h2>
                <p>Your operational modules for driver management, vehicle inventory,<br>and delivery orders will be available here.</p>
            </div>
        <% } %>

        <div class="footer">
            Shopee Delivery System v1.0 &middot; Server Time: <%= new java.util.Date() %>
        </div>
    </div>
</body>
</html>
