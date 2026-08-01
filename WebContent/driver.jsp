<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="edu.iacademy.cselec05.pm_rima.util.DatabaseConfig" %>
<%
    HttpSession sess = request.getSession(false);
    if (sess == null || sess.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String role = (String) sess.getAttribute("role");
    if (!"SUPERVISOR".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String username = (String) sess.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Driver Management - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/common.css">
    <style>
        body {
            display: flex;
            flex-direction: column;
        }
        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(249, 115, 22, 0.06) 0%, rgba(0,0,0,0) 70%);
            top: -150px;
            left: -100px;
            z-index: 0;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Driver Management</h2>
        <div class="nav-links">
            <a href="index.jsp">Dashboard</a>
            <a href="driver.jsp" class="active">Drivers</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <!-- Driver List -->
        <div class="glass-card">
            <h2 class="card-title">Driver Directory</h2>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");

                if ("true".equals(success)) {
            %>
                <div class="alert alert-success">Driver operation executed successfully!</div>
            <%
                } else if ("true".equals(error)) {
            %>
                <div class="alert alert-error">Something went wrong. Please check your data.</div>
            <%
                }
            %>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Driver Name</th>
                            <th>License Number</th>
                            <th>Phone</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DatabaseConfig.getConnection();
                                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM drivers");
                                 ResultSet rs = ps.executeQuery()) {
                                
                                boolean hasDrivers = false;
                                while (rs.next()) {
                                    hasDrivers = true;
                                    String stat = rs.getString("status");
                                    String badgeClass = "Available".equals(stat) ? "badge-available" : "badge-unavailable";
                        %>
                                    <tr>
                                        <td><%= rs.getInt("driver_id") %></td>
                                        <td><strong><%= rs.getString("name") %></strong></td>
                                        <td><%= rs.getString("license_number") %></td>
                                        <td><%= rs.getString("phone") %></td>
                                        <td><span class="badge <%= badgeClass %>"><%= stat %></span></td>
                                        <td>
                                            <a class="action-link" onclick="populateEditForm(<%= rs.getInt("driver_id") %>, '<%= rs.getString("name") %>', '<%= rs.getString("license_number") %>', '<%= rs.getString("phone") %>', '<%= rs.getString("status") %>')">Edit</a>
                                            <a href="DriverServlet?action=delete&driverId=<%= rs.getInt("driver_id") %>" class="action-link delete" onclick="return confirm('Delete this driver?');">Delete</a>
                                        </td>
                                    </tr>
                        <%
                                }
                                if (!hasDrivers) {
                        %>
                                    <tr>
                                        <td colspan="6" style="text-align: center; color: var(--text-secondary); padding: 32px 0;">No drivers registered yet.</td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="6" style="color: var(--danger-color); text-align: center;">Error retrieving driver list.</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Add/Edit Form -->
        <div class="glass-card">
            <h2 id="form-header" class="card-title">Add Driver</h2>
            <form action="DriverServlet" method="post" id="driver-form">
                <input type="hidden" name="action" id="form-action" value="add">
                <input type="hidden" name="driverId" id="driverId" value="">

                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" class="form-input" placeholder="e.g. John Doe" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="licenseNumber">License Number</label>
                    <input type="text" id="licenseNumber" name="licenseNumber" class="form-input" placeholder="e.g. DL-12345" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" class="form-input" placeholder="e.g. 09123456789" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Available">Available</option>
                        <option value="Unavailable">Unavailable</option>
                    </select>
                </div>

                <button type="submit" id="submit-btn" class="btn-submit">Add Driver</button>
                <button type="button" class="btn-clear" onclick="resetForm()">Clear Form</button>
            </form>
        </div>
    </div>

    <script>
        function populateEditForm(id, name, license, phone, status) {
            document.getElementById('form-header').innerText = 'Edit Driver';
            document.getElementById('form-action').value = 'edit';
            document.getElementById('driverId').value = id;
            document.getElementById('name').value = name;
            document.getElementById('licenseNumber').value = license;
            document.getElementById('phone').value = phone;
            document.getElementById('status').value = status;
            document.getElementById('submit-btn').innerText = 'Update Driver';
        }

        function resetForm() {
            document.getElementById('form-header').innerText = 'Add Driver';
            document.getElementById('form-action').value = 'add';
            document.getElementById('driverId').value = '';
            document.getElementById('driver-form').reset();
            document.getElementById('submit-btn').innerText = 'Add Driver';
        }
    </script>
</body>
</html>
