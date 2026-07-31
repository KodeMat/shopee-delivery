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
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(255, 255, 255, 0.03);
            --card-border: rgba(255, 255, 255, 0.08);
            --primary-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --text-accent: #fb923c;
            --error-bg: rgba(239, 68, 68, 0.1);
            --error-border: rgba(239, 68, 68, 0.2);
            --info-bg: rgba(59, 130, 246, 0.1);
            --info-border: rgba(59, 130, 246, 0.2);
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
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            position: relative;
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
        .info-banner {
            background: var(--info-bg);
            border: 1px solid var(--info-border);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 13px;
            color: #93c5fd;
            margin-bottom: 20px;
            line-height: 1.5;
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
        .form-row {
            display: flex;
            gap: 12px;
        }
        .form-group {
            margin-bottom: 18px;
            flex: 1;
        }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }
        .form-input {
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
        .form-input:focus {
            border-color: #f97316;
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.15);
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            margin-top: 8px;
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
        .back-link {
            display: inline-block;
            margin-top: 20px;
            font-size: 13px;
            color: var(--text-accent);
            text-decoration: none;
            transition: color 0.15s ease;
        }
        .back-link:hover {
            color: #f97316;
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
