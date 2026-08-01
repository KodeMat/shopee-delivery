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
    <link rel="stylesheet" href="css/common.css">
    <style>
        :root {
            --primary-glow: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            --accent-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-accent: #60a5fa;
        }
        body {
            display: flex;
            flex-direction: column;
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
        .navbar h2 {
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
        .form-input:focus {
            border-color: rgba(59, 130, 246, 0.5);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }
        .btn-submit {
            background: var(--accent-glow);
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
