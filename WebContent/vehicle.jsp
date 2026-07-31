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
    <title>Vehicle Management - Shopee Delivery Logistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(255, 255, 255, 0.02);
            --card-border: rgba(255, 255, 255, 0.08);
            --primary-glow: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --text-accent: #fb923c;
            --success-color: #10b981;
            --warning-color: #f59e0b;
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
            background: radial-gradient(circle, rgba(249, 115, 22, 0.06) 0%, rgba(0,0,0,0) 70%);
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
            background: linear-gradient(135deg, #ffffff 40%, #fdba74 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .nav-links a {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 500;
            margin-left: 20px;
            transition: color 0.2s;
        }
        .nav-links a:hover, .nav-links a.active {
            color: var(--text-accent);
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
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .badge-available {
            background: rgba(16, 185, 129, 0.1);
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: var(--success-color);
        }
        .badge-inuse {
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.2);
            color: var(--warning-color);
        }
        .badge-maintenance {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: var(--danger-color);
        }
        .action-link {
            color: var(--text-accent);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            margin-right: 12px;
            cursor: pointer;
        }
        .action-link.delete {
            color: var(--danger-color);
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
        .form-input, select {
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
        .form-input:focus, select:focus {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(249, 115, 22, 0.5);
            box-shadow: 0 0 0 3px rgba(249, 115, 22, 0.15);
        }
        select option {
            background-color: var(--bg-color);
            color: var(--text-primary);
        }
        .btn-submit {
            display: block;
            width: 100%;
            background: var(--primary-glow);
            border: none;
            border-radius: 12px;
            padding: 12px;
            color: white;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 12px;
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(249, 115, 22, 0.3);
        }
        .btn-clear {
            display: block;
            width: 100%;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 12px;
            color: var(--text-primary);
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-clear:hover {
            background: rgba(255, 255, 255, 0.06);
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
        <h2>Vehicle Management</h2>
        <div class="nav-links">
            <a href="index.jsp">Dashboard</a>
            <a href="driver.jsp">Drivers</a>
            <a href="vehicle.jsp" class="active">Vehicles</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <!-- Vehicle List -->
        <div class="glass-card">
            <h2 class="card-title">Fleet Directory</h2>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");

                if ("true".equals(success)) {
            %>
                <div class="alert alert-success">Vehicle operation executed successfully!</div>
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
                            <th>Plate Number</th>
                            <th>Type</th>
                            <th>Brand</th>
                            <th>Model</th>
                            <th>Capacity (kg)</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DatabaseConfig.getConnection();
                                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM vehicles");
                                 ResultSet rs = ps.executeQuery()) {
                                
                                boolean hasVehicles = false;
                                while (rs.next()) {
                                    hasVehicles = true;
                                    String stat = rs.getString("status");
                                    String badgeClass = "Available".equals(stat) ? "badge-available" :
                                                       ("Maintenance".equals(stat) ? "badge-maintenance" : "badge-unavailable");
                        %>
                                    <tr>
                                        <td><%= rs.getInt("vehicle_id") %></td>
                                        <td><strong><%= rs.getString("plate_number") %></strong></td>
                                        <td><%= rs.getString("vehicle_type") %></td>
                                        <td><%= rs.getString("brand") %></td>
                                        <td><%= rs.getString("model") %></td>
                                        <td><%= rs.getInt("capacity") %></td>
                                        <td><span class="badge <%= badgeClass %>"><%= stat %></span></td>
                                        <td>
                                            <a class="action-link" onclick="populateEditForm(<%= rs.getInt("vehicle_id") %>, '<%= rs.getString("plate_number") %>', '<%= rs.getString("vehicle_type") %>', '<%= rs.getString("brand") %>', '<%= rs.getString("model") %>', <%= rs.getInt("capacity") %>, '<%= rs.getString("status") %>')">Edit</a>
                                            <a href="VehicleServlet?action=delete&vehicleId=<%= rs.getInt("vehicle_id") %>" class="action-link delete" onclick="return confirm('Delete this vehicle?');">Delete</a>
                                        </td>
                                    </tr>
                        <%
                                }
                                if (!hasVehicles) {
                        %>
                                    <tr>
                                        <td colspan="8" style="text-align: center; color: var(--text-secondary); padding: 32px 0;">No vehicles registered in fleet yet.</td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="8" style="color: var(--danger-color); text-align: center;">Error retrieving vehicle list.</td>
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
            <h2 id="form-header" class="card-title">Add Vehicle</h2>
            <form action="VehicleServlet" method="post" id="vehicle-form">
                <input type="hidden" name="action" id="form-action" value="add">
                <input type="hidden" name="vehicleId" id="vehicleId" value="">

                <div class="form-group">
                    <label for="plateNumber">Plate Number</label>
                    <input type="text" id="plateNumber" name="plateNumber" class="form-input" placeholder="e.g. ABC-1234" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="vehicleType">Vehicle Type</label>
                    <select id="vehicleType" name="vehicleType">
                        <option value="Van">Van</option>
                        <option value="Truck">Truck</option>
                        <option value="Motorcycle">Motorcycle</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="brand">Brand</label>
                    <input type="text" id="brand" name="brand" class="form-input" placeholder="e.g. Toyota" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="model">Model</label>
                    <input type="text" id="model" name="model" class="form-input" placeholder="e.g. Hiace" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="capacity">Capacity (kg)</label>
                    <input type="number" id="capacity" name="capacity" class="form-input" placeholder="e.g. 1000" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Available">Available</option>
                        <option value="Unavailable">Unavailable</option>
                        <option value="Maintenance">Maintenance</option>
                    </select>
                </div>

                <button type="submit" id="submit-btn" class="btn-submit">Add Vehicle</button>
                <button type="button" class="btn-clear" onclick="resetForm()">Clear Form</button>
            </form>
        </div>
    </div>

    <script>
        function populateEditForm(id, plate, type, brand, model, capacity, status) {
            document.getElementById('form-header').innerText = 'Edit Vehicle';
            document.getElementById('form-action').value = 'edit';
            document.getElementById('vehicleId').value = id;
            document.getElementById('plateNumber').value = plate;
            document.getElementById('vehicleType').value = type;
            document.getElementById('brand').value = brand;
            document.getElementById('model').value = model;
            document.getElementById('capacity').value = capacity;
            document.getElementById('status').value = status;
            document.getElementById('submit-btn').innerText = 'Update Vehicle';
        }

        function resetForm() {
            document.getElementById('form-header').innerText = 'Add Vehicle';
            document.getElementById('form-action').value = 'add';
            document.getElementById('vehicleId').value = '';
            document.getElementById('vehicle-form').reset();
            document.getElementById('submit-btn').innerText = 'Add Vehicle';
        }
    </script>
</body>
</html>
