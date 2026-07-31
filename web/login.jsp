<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String usernameVal = request.getAttribute("username") != null ? (String) request.getAttribute("username") : "";
    String errorMessage = (String) request.getAttribute("errorMessage");
    boolean isRegistered = "true".equals(request.getParameter("registered"));
    boolean isLoggedOut = "true".equals(request.getParameter("logout"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Shopee Delivery System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f5f5f5;
            color: #333;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .login-header h1 {
            font-size: 22px;
            font-weight: 700;
            color: #222;
            margin-bottom: 4px;
        }

        .login-header p {
            font-size: 14px;
            color: #888;
        }

        .login-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 32px 28px;
        }

        .alert {
            padding: 10px 14px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .alert-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
        }

        .alert-success {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            color: #15803d;
        }

        .form-group {
            margin-bottom: 16px;
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

        .input-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #888;
            cursor: pointer;
            font-size: 12px;
            font-family: inherit;
            font-weight: 500;
        }

        .toggle-password:hover {
            color: #555;
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

        .login-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: #888;
        }

        .demo-section {
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #eee;
        }

        .demo-title {
            font-size: 11px;
            font-weight: 600;
            color: #aaa;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .demo-btn {
            display: inline-block;
            background: #f9f9f9;
            border: 1px solid #e5e5e5;
            border-radius: 4px;
            padding: 5px 10px;
            margin-right: 6px;
            margin-bottom: 4px;
            font-size: 12px;
            font-family: 'SF Mono', 'Consolas', monospace;
            color: #555;
            cursor: pointer;
            transition: background 0.1s;
        }

        .demo-btn:hover {
            background: #f0f0f0;
            border-color: #ccc;
        }
    </style>
</head>
<body>
    <div class="login-wrapper">
        <div class="login-header">
            <h1>Shopee Delivery System</h1>
            <p>Sign in to your account</p>
        </div>

        <div class="login-card">
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                <div class="alert alert-error"><%= errorMessage %></div>
            <% } %>
            <% if (isRegistered) { %>
                <div class="alert alert-success">Account created successfully. Sign in with your new credentials.</div>
            <% } %>
            <% if (isLoggedOut) { %>
                <div class="alert alert-success">You have been signed out.</div>
            <% } %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="Enter username" value="<%= usernameVal %>" required autofocus>
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Enter password" required>
                        <button type="button" class="toggle-password" onclick="togglePass()">Show</button>
                    </div>
                </div>
                <button type="submit" class="btn-submit">Sign In</button>
            </form>

            <div class="demo-section">
                <div class="demo-title">Demo Accounts</div>
                <span class="demo-btn" onclick="fillCreds('admin','admin123')">admin / admin123</span>
                <span class="demo-btn" onclick="fillCreds('supervisor','supervisor123')">supervisor / supervisor123</span>
            </div>
        </div>

        <div class="login-footer">
            Account provisioning is managed by administrators.
        </div>
    </div>

    <script>
        function togglePass() {
            var p = document.getElementById('password');
            var b = p.nextElementSibling;
            if (p.type === 'password') { p.type = 'text'; b.textContent = 'Hide'; }
            else { p.type = 'password'; b.textContent = 'Show'; }
        }
        function fillCreds(u, p) {
            document.getElementById('username').value = u;
            document.getElementById('password').value = p;
        }
    </script>
</body>
</html>
