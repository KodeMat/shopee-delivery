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
    <link rel="stylesheet" href="css/common.css?v=2">
</head>
<body>
    <div class="navbar">
        <h2>Shopee Delivery Logistics</h2>
        <div class="nav-right">
            <div class="nav-links">
                <a href="index.jsp">Dashboard</a>
                <a href="driver.jsp">Drivers</a>
                <a href="vehicle.jsp" class="active">Vehicles</a>
                <a href="orders.jsp">Orders</a>
            </div>
            <span class="role-tag supervisor"><%= role %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Sign Out</a>
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
