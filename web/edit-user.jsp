<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.model.User" %>
<%
    User editUser = (User) request.getAttribute("editUser");
    if (editUser == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    User currentUser = (User) session.getAttribute("user");
    String currentRole = (String) session.getAttribute("role");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Supervisor - Shopee Delivery System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f5f5f5;
            color: #333;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-wrapper {
            width: 100%;
            max-width: 460px;
            padding: 20px;
        }

        .form-header {
            margin-bottom: 24px;
        }

        .form-header h1 {
            font-size: 20px;
            font-weight: 700;
            color: #222;
            margin-bottom: 4px;
        }

        .form-header p {
            font-size: 13px;
            color: #888;
        }

        .form-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 28px 24px;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            color: #b91c1c;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #555;
            margin-bottom: 6px;
        }

        .form-input, .form-select {
            width: 100%;
            padding: 10px 12px;
            font-size: 14px;
            font-family: inherit;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            color: #333;
            background: #fff;
            outline: none;
            transition: border-color 0.15s;
        }

        .form-input:focus, .form-select:focus {
            border-color: #ee4d2d;
            box-shadow: 0 0 0 2px rgba(238, 77, 45, 0.1);
        }

        .form-input[readonly] {
            background: #f9f9f9;
            color: #888;
        }

        .form-select option {
            background: #fff;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn-submit {
            flex: 1;
            padding: 11px;
            background: #ee4d2d;
            border: none;
            border-radius: 6px;
            color: #fff;
            font-size: 14px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            transition: background 0.15s;
        }

        .btn-submit:hover { background: #d63e1f; }

        .btn-cancel {
            padding: 11px 20px;
            background: #fff;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            color: #555;
            font-size: 14px;
            font-weight: 500;
            font-family: inherit;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }

        .btn-cancel:hover { background: #f9f9f9; }
    </style>
</head>
<body>
    <div class="form-wrapper">
        <div class="form-header">
            <h1>Edit Supervisor</h1>
            <p>Update account details for <strong><%= editUser.getUsername() %></strong></p>
        </div>

        <div class="form-card">
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert-error"><%= errorMessage %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/edit-user" method="post">
                <input type="hidden" name="user_id" value="<%= editUser.getUserId() %>">

                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" class="form-input" value="<%= editUser.getUsername() %>" readonly>
                </div>

                <div class="form-group">
                    <label class="form-label" for="full_name">Full Name</label>
                    <input type="text" id="full_name" name="full_name" class="form-input"
                           value="<%= editUser.getFullName() %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-input"
                           value="<%= editUser.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="status">Status</label>
                    <select id="status" name="status" class="form-select">
                        <option value="ACTIVE" <%= "ACTIVE".equals(editUser.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="INACTIVE" <%= "INACTIVE".equals(editUser.getStatus()) ? "selected" : "" %>>Inactive</option>
                    </select>
                </div>

                <div class="form-actions">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-submit">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
