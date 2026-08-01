<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/common.css?v=2">
</head>
<body class="auth-page">
    <div class="container">
        <div class="logo-container">
            <div class="logo-box">S</div>
            <h1>Request Access</h1>
            <p>Create a Supervisor Account Request</p>
        </div>

        <div class="glass-card">
            <%
                String error = request.getParameter("error");
                if ("exists".equals(error)) {
            %>
                <div class="alert alert-error">Username is already taken.</div>
            <%
                } else if ("empty".equals(error)) {
            %>
                <div class="alert alert-error">All fields are required.</div>
            <%
                } else if ("db".equals(error)) {
            %>
                <div class="alert alert-error">Database connection error. Please try again.</div>
            <%
                }
            %>

            <form action="AuthServlet" method="post">
                <input type="hidden" name="action" value="signup">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input" placeholder="Choose a username" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Choose a password" required>
                </div>

                <button type="submit" class="btn-submit">Submit Registration</button>
            </form>

            <div class="login-link">
                Already registered? <a href="login.jsp">Login here</a>
            </div>
        </div>
    </div>
</body>
</html>
