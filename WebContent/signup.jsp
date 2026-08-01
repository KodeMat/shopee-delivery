<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Shopee Delivery Logistics</title>
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
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(249, 115, 22, 0.12) 0%, rgba(0,0,0,0) 70%);
            top: -100px;
            left: -100px;
            z-index: 0;
        }
        .container {
            width: 100%;
            max-width: 450px;
            padding: 24px;
            z-index: 10;
            display: block;
        }
        .logo-container {
            text-align: center;
            margin-bottom: 32px;
        }
        .logo-box {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            width: 70px;
            height: 70px;
            border-radius: 20px;
            background: rgba(249, 115, 22, 0.1);
            border: 1px solid rgba(249, 115, 22, 0.2);
            color: var(--text-accent);
            font-size: 2rem;
            font-weight: 700;
            box-shadow: 0 8px 30px rgba(249, 115, 22, 0.15);
            margin-bottom: 16px;
        }
        .logo-container h1 {
            font-size: 1.8rem;
            font-weight: 700;
            letter-spacing: -0.025em;
            background: linear-gradient(135deg, #ffffff 40%, #fdba74 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .logo-container p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-top: 6px;
        }
        .glass-card {
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            font-size: 0.85rem;
        }
        .form-input {
            padding: 12px 16px;
        }
        .btn-submit {
            padding: 14px;
            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
            margin-top: 24px;
        }
        .btn-submit:hover {
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.3);
        }
        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid var(--error-border);
            color: #f87171;
        }
        .login-link {
            text-align: center;
            margin-top: 24px;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        .login-link a {
            color: var(--text-accent);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .login-link a:hover {
            color: #f97316;
        }
    </style>
</head>
<body>
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
