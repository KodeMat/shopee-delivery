<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String currentRole = (String) session.getAttribute("role");
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String usernameVal = request.getAttribute("username") != null ? (String) request.getAttribute("username") : "";
    String fullNameVal = request.getAttribute("fullName") != null ? (String) request.getAttribute("fullName") : "";
    String emailVal = request.getAttribute("email") != null ? (String) request.getAttribute("email") : "";
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Supervisor - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/common.css?v=2">
</head>
<body class="auth-page">
    <div class="form-wrapper">
        <div class="form-header">
            <h1>Register New Supervisor</h1>
            <p>Create an operational account for the delivery system</p>
        </div>

        <div class="form-card">
            <div class="info-banner">
                New accounts are assigned the <strong>Supervisor</strong> role with access to driver, vehicle, and order management.
            </div>

            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert-error"><%= errorMessage %></div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="role" value="SUPERVISOR">

                <div class="form-group">
                    <label class="form-label" for="full_name">Full Name</label>
                    <input type="text" id="full_name" name="full_name" class="form-input"
                           placeholder="e.g. Juan Dela Cruz" value="<%= fullNameVal %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-input"
                           placeholder="user@company.com" value="<%= emailVal %>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="Choose a username" value="<%= usernameVal %>" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Min 6 characters" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="confirm_password">Confirm</label>
                        <input type="password" id="confirm_password" name="confirm_password" class="form-input"
                               placeholder="Re-enter" required>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Create Supervisor Account</button>
            </form>

            <a href="<%= request.getContextPath() %>/index.jsp" class="back-link">&larr; Back to Dashboard</a>
        </div>
    </div>

    <script>
        function validateForm() {
            var p = document.getElementById('password').value;
            var c = document.getElementById('confirm_password').value;
            if (p !== c) { alert('Passwords do not match.'); return false; }
            if (p.length < 6) { alert('Password must be at least 6 characters.'); return false; }
            return true;
        }
    </script>
</body>
</html>
