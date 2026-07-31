<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.DatabaseConfig" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || !"ADMIN".equals(sess.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) sess.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(255, 255, 255, 0.02);
            --card-border: rgba(255, 255, 255, 0.08);
            --primary-glow: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --accent-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --text-accent: #60a5fa;
            --success-color: #10b981;
            --danger-color: #ef4444;
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
            flex-direction: column;
            overflow-x: hidden;
            position: relative;
        }
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.08) 0%, rgba(0,0,0,0) 70%);
            top: -150px;
            left: -100px;
            z-index: 0;
        }
        .navbar {
            background: rgba(11, 15, 25, 0.8);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--card-border);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 100;
        }
        .navbar h2 {
            font-size: 1.4rem;
            font-weight: 700;
            background: linear-gradient(135deg, #ffffff 40%, #93c5fd 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .nav-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .nav-info span {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        .btn-logout {
            color: var(--danger-color);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s;
        }
        .btn-logout:hover {
            opacity: 0.8;
        }
        .container {
            max-width: 1200px;
            width: 90%;
            margin: 40px auto;
            z-index: 10;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        @media (max-width: 900px) {
            .container {
                grid-template-columns: 1fr;
            }
        }
        .glass-card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }
        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 24px;
            color: var(--text-accent);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .table-container {
            overflow-x: auto;
            margin-top: 16px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        th, td {
            padding: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }
        th {
            color: var(--text-secondary);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
        }
        td {
            font-size: 0.95rem;
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            background: rgba(249, 115, 22, 0.1);
            border: 1px solid rgba(249, 115, 22, 0.2);
            color: var(--accent-glow);
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .btn-approve {
            background: var(--primary-glow);
            border: none;
            border-radius: 8px;
            padding: 8px 16px;
            color: white;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-approve:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 0.8rem;
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
            padding: 12px;
            color: var(--text-primary);
            font-size: 0.95rem;
            outline: none;
            transition: all 0.3s;
        }
        .form-input:focus {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(59, 130, 246, 0.5);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }
        .btn-submit {
            display: block;
            width: 100%;
            background: var(--accent-glow);
            border: none;
            border-radius: 12px;
            padding: 12px;
            color: white;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
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
            background-color: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #f87171;
        }
        .alert-success {
            background-color: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #34d399;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Parcel Delivery Administration</h2>
        <div class="nav-info">
            <span>Welcome, <strong><%= username %></strong> (Admin)</span>
            <a href="AuthServlet?action=logout" class="btn-logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <!-- Main Panel: Approval Table -->
        <div class="glass-card">
            <h2 class="card-title">Pending User Approvals</h2>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");

                if ("approved".equals(success)) {
            %>
                <div class="alert alert-success">User registration approved successfully!</div>
            <%
                } else if ("registered".equals(success)) {
            %>
                <div class="alert alert-success">New supervisor registered directly!</div>
            <%
                } else if ("exists".equals(error)) {
            %>
                <div class="alert alert-error">Username is already taken.</div>
            <%
                } else if ("empty".equals(error)) {
            %>
                <div class="alert alert-error">All fields are required.</div>
            <%
                } else if ("db".equals(error)) {
            %>
                <div class="alert alert-error">Database error occurred. Please try again.</div>
            <%
                }
            %>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Username</th>
                            <th>Requested Role</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DatabaseConfig.getConnection();
                                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE status = 'UNREGISTERED'");
                                 ResultSet rs = ps.executeQuery()) {
                                
                                boolean hasPending = false;
                                while (rs.next()) {
                                    hasPending = true;
                        %>
                                    <tr>
                                        <td><%= rs.getInt("user_id") %></td>
                                        <td><strong><%= rs.getString("username") %></strong></td>
                                        <td><%= rs.getString("role") %></td>
                                        <td><span class="status-badge">Unregistered</span></td>
                                        <td>
                                            <form action="AdminServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="userId" value="<%= rs.getInt("user_id") %>">
                                                <button type="submit" class="btn-approve">Approve & Register</button>
                                            </form>
                                        </td>
                                    </tr>
                        <%
                                }
                                if (!hasPending) {
                        %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-secondary); padding: 32px 0;">
                                            No pending user registration requests.
                                        </td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="5" style="color: var(--danger-color); text-align: center;">Error listing pending users.</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Sidebar Panel: Register Direct User -->
        <div class="glass-card">
            <h2 class="card-title">Register Supervisor</h2>
            <form action="AdminServlet" method="post">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input" placeholder="New username" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input" placeholder="Password" required>
                </div>

                <button type="submit" class="btn-submit">Create Account</button>
            </form>
        </div>
    </div>
</body>
</html>
