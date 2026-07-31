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
    <title>Login - Shopee Delivery Logistics</title>
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
        .login-wrapper {
            width: 100%;
            max-width: 420px;
            padding: 24px;
            position: relative;
            z-index: 1;
        }
        .login-header {
            text-align: center;
            margin-bottom: 32px;
        }
        .login-header h1 {
            font-size: 26px;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #ffffff 0%, #9ca3af 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }
        .login-header p {
            font-size: 14px;
            color: var(--text-secondary);
        }
        .login-card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 32px;
            backdrop-filter: blur(16px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        .alert-error {
            background: var(--error-bg);
            border: 1px solid var(--error-border);
            color: #fca5a5;
        }
        .alert-success {
            background: var(--success-bg);
            border: 1px solid var(--success-border);
            color: #6ee7b7;
        }
        .form-group {
            margin-bottom: 20px;
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
        .input-wrapper {
            position: relative;
        }
        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
        }
        .toggle-password:hover {
            color: var(--text-primary);
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
        .login-footer {
            text-align: center;
            margin-top: 24px;
            font-size: 13px;
            color: var(--text-secondary);
        }
        .demo-section {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid var(--card-border);
        }
        .demo-title {
            font-size: 11px;
            font-weight: 600;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 12px;
        }
        .demo-btn {
            display: inline-block;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid var(--card-border);
            border-radius: 6px;
            padding: 6px 12px;
            margin-right: 6px;
            margin-bottom: 6px;
            font-size: 12px;
            font-family: monospace;
            color: var(--text-accent);
            cursor: pointer;
            transition: background 0.15s ease;
        }
        .demo-btn:hover {
            background: rgba(255, 255, 255, 0.08);
            border-color: rgba(249, 115, 22, 0.3);
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
