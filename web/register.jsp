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
    <title>Register Supervisor - Shopee Delivery System</title>
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

        .info-banner {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 6px;
            padding: 10px 14px;
            font-size: 13px;
            color: #1e40af;
            margin-bottom: 20px;
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

        .form-row {
            display: flex;
            gap: 12px;
        }

        .form-group {
            margin-bottom: 14px;
            flex: 1;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: #555;
            margin-bottom: 6px;
        }

        .form-input {
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

        .form-input:focus {
            border-color: #ee4d2d;
            box-shadow: 0 0 0 2px rgba(238, 77, 45, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 11px;
            margin-top: 8px;
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

        .btn-submit:hover {
            background: #d63e1f;
        }

        .back-link {
            display: inline-block;
            margin-top: 16px;
            font-size: 13px;
            color: #ee4d2d;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
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
