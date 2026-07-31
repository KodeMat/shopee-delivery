<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(249, 115, 22, 0.12) 0%, rgba(0,0,0,0) 70%);
            top: -100px;
            left: -100px;
            z-index: 0;
        }
        body::after {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(234, 88, 12, 0.08) 0%, rgba(0,0,0,0) 70%);
            bottom: -150px;
            right: -100px;
            z-index: 0;
        }
        .container {
            width: 100%;
            max-width: 450px;
            padding: 24px;
            z-index: 10;
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
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text-secondary);
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }
        .form-input {
            width: 100%;
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 12px 16px;
            color: var(--text-primary);
            font-size: 0.95rem;
            outline: none;
            transition: all 0.3s;
        }
        .form-input:focus {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(249, 115, 22, 0.5);
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.15);
        }
        .btn-submit {
            display: block;
            width: 100%;
            background: var(--primary-glow);
            border: none;
            border-radius: 12px;
            padding: 14px;
            color: white;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
            margin-top: 24px;
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.3);
        }
        .alert {
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 0.9rem;
            margin-bottom: 20px;
            text-align: center;
        }
        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid var(--error-border);
            color: #f87171;
        }
        .alert-success {
            background-color: var(--success-bg);
            border: 1px solid var(--success-border);
            color: #34d399;
        }
        .signup-link {
            text-align: center;
            margin-top: 24px;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        .signup-link a {
            color: var(--text-accent);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .signup-link a:hover {
            color: #f97316;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo-container">
            <div class="logo-box">S</div>
            <h1>Logistics Portal</h1>
            <p>Parcel Delivery Management System</p>
        </div>

        <div class="glass-card">
            <%
                String error = request.getParameter("error");
                String signupSuccess = request.getParameter("signup_success");
                String loggedOut = request.getParameter("logged_out");

                if ("invalid".equals(error)) {
            %>
                <div class="alert alert-error">Invalid username or password.</div>
            <%
                } else if ("pending".equals(error)) {
            %>
                <div class="alert alert-error">Your account is pending registration approval by the Admin.</div>
            <%
                } else if ("db".equals(error)) {
            %>
                <div class="alert alert-error">Database connection error. Please try again.</div>
            <%
                }

                if ("true".equals(signupSuccess)) {
            %>
                <div class="alert alert-success">Signup request submitted successfully! Please wait for Admin approval.</div>
            <%
                } else if ("true".equals(loggedOut)) {
            %>
                <div class="alert alert-success">You have been logged out successfully.</div>
            <%
                }
            %>

            <form action="AuthServlet" method="post">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input" placeholder="Enter username" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Enter password" required>
                </div>

                <button type="submit" class="btn-submit">Sign In</button>
            </form>

            <div class="signup-link">
                Don't have an account? <a href="signup.jsp">Request Access</a>
            </div>
        </div>
    </div>
</body>
</html>
