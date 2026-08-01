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
    <link rel="stylesheet" href="css/common.css?v=2">
</head>
<body class="auth-page">
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
