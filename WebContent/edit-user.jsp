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
    <title>Edit Supervisor - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/common.css?v=2">
</head>
<body class="auth-page">
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
                        <option value="ACTIVE" <%= "ACTIVE".equalsIgnoreCase(editUser.getStatus()) ? "selected" : "" %>>Active</option>
                        <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(editUser.getStatus()) ? "selected" : "" %>>Inactive</option>
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
