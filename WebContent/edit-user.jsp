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
    <link rel="stylesheet" href="css/common.css">
    <style>
        :root {
            --card-bg: rgba(255, 255, 255, 0.03);
        }
        body {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(249, 115, 22, 0.08) 0%, rgba(0,0,0,0) 70%);
            top: -150px;
            left: -100px;
            z-index: 0;
            pointer-events: none;
        }
        .form-wrapper {
            width: 100%;
            max-width: 480px;
            padding: 24px;
            position: relative;
            z-index: 1;
        }
        .form-header {
            margin-bottom: 24px;
            text-align: center;
        }
        .form-header h1 {
            font-size: 24px;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #ffffff 0%, #9ca3af 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .form-header p {
            font-size: 14px;
            color: var(--text-secondary);
        }
        .form-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 32px;
            backdrop-filter: blur(16px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        .alert-error {
            background: var(--error-bg);
            border: 1px solid var(--error-border);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 13px;
            color: #fca5a5;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }
        .form-input, .form-select {
            width: 100%;
            padding: 12px 16px;
            font-size: 14px;
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid var(--card-border);
            border-radius: 8px;
            color: var(--text-primary);
            outline: none;
            transition: all 0.2s ease;
        }
        .form-input:focus, .form-select:focus {
            border-color: #f97316;
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.15);
        }
        .form-input[readonly] {
            background: rgba(0, 0, 0, 0.4);
            color: var(--text-secondary);
        }
        .form-select option {
            background: #0b0f19;
            color: #f3f4f6;
        }
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        .btn-submit {
            flex: 1;
            padding: 12px;
            background: var(--primary-glow);
            border: none;
            border-radius: 8px;
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
            box-shadow: 0 4px 14px rgba(249, 115, 22, 0.3);
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.4);
        }
        .btn-cancel {
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--card-border);
            border-radius: 8px;
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: background 0.15s ease;
        }
        .btn-cancel:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--text-primary);
        }
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
