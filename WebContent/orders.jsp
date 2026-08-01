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
    <title>Delivery Orders - Shopee Delivery Logistics</title>
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
                <a href="vehicle.jsp">Vehicles</a>
                <a href="orders.jsp" class="active">Orders</a>
            </div>
            <span class="role-tag supervisor"><%= role %></span>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Sign Out</a>
        </div>
    </div>

    <div class="container">
        <!-- Order List & Assignment panel -->
        <div class="glass-card">
            <h2 class="card-title">Order Catalog & Fleet Assignment</h2>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");

                if ("true".equals(success)) {
            %>
                <div class="alert alert-success">Order operation executed successfully!</div>
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
                            <th class="col-order-details">Order details</th>
                            <th class="col-cargo-weight">Cargo Weight</th>
                            <th class="col-status">Status</th>
                            <th class="col-dispatch">Assigned Dispatch</th>
                            <th class="col-actions">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection conn = DatabaseConfig.getConnection();
                                 PreparedStatement ps = conn.prepareStatement(
                                     "SELECT o.*, d.name AS driver_name, v.plate_number, v.vehicle_type " +
                                     "FROM delivery_orders o " +
                                     "LEFT JOIN drivers d ON o.driver_id = d.driver_id " +
                                     "LEFT JOIN vehicles v ON o.vehicle_id = v.vehicle_id");
                                 ResultSet rs = ps.executeQuery()) {
                                
                                boolean hasOrders = false;
                                while (rs.next()) {
                                    hasOrders = true;
                                    int orderId = rs.getInt("order_id");
                                    String orderNum = rs.getString("order_number");
                                    String recName = rs.getString("recipient_name");
                                    String recAddr = rs.getString("recipient_address");
                                    double weight = rs.getDouble("weight");
                                    String stat = rs.getString("status");
                                    
                                    String badgeClass = "badge-pending";
                                    if ("Assigned".equals(stat)) badgeClass = "badge-assigned";
                                    else if ("In Transit".equals(stat)) badgeClass = "badge-transit";
                                    else if ("Delivered".equals(stat)) badgeClass = "badge-delivered";
                                    else if ("Cancelled".equals(stat)) badgeClass = "badge-cancelled";

                                    String driverName = rs.getString("driver_name");
                                    String vehiclePlate = rs.getString("plate_number");
                                    String vehicleType = rs.getString("vehicle_type");
                        %>
                                    <tr>
                                        <td class="col-order-details">
                                            <strong>#<%= orderNum %></strong><br>
                                            <span style="font-size: 0.85rem; color: var(--text-secondary);">
                                                To: <%= recName %><br>
                                                Addr: <%= recAddr %>
                                            </span>
                                        </td>
                                        <td class="col-cargo-weight"><%= weight %> kg</td>
                                        <td class="col-status">
                                            <span class="badge <%= badgeClass %>"><%= stat %></span>
                                        </td>
                                        <td class="col-dispatch">
                                            <% if (driverName != null) { %>
                                                <div style="font-size: 0.85rem; line-height: 1.4;">
                                                    👤 <%= driverName %><br>
                                                    🚚 <%= vehiclePlate %> (<%= vehicleType %>)
                                                </div>
                                            <% } else { %>
                                                <span style="color: var(--text-secondary); font-size: 0.85rem; font-style: italic;">Unassigned</span>
                                            <% } %>
                                        </td>
                                        <td class="col-actions">
                                            <div class="actions-cell-wrapper">
                                                <form action="set-status" method="post" class="actions-form">
                                                    <input type="hidden" name="orderId" value="<%= orderNum %>">
                                                    <div>
                                                        <select name="status" class="small-select small-select-fixed">
                                                            <option value="Pending" <%= "Pending".equals(stat) ? "selected" : "" %>>Pending</option>
                                                            <option value="Assigned" <%= "Assigned".equals(stat) ? "selected" : "" %>>Assigned</option>
                                                            <option value="In Transit" <%= "In Transit".equals(stat) ? "selected" : "" %>>In Transit</option>
                                                            <option value="Delivered" <%= "Delivered".equals(stat) ? "selected" : "" %>>Delivered</option>
                                                            <option value="Cancelled" <%= "Cancelled".equals(stat) ? "selected" : "" %>>Cancelled</option>
                                                        </select>
                                                    </div>

                                                    <div class="actions-btn-group">
                                                        <button type="submit" class="btn-inline">Set Status</button>
                                                        <!-- Fleet Assignment Trigger Button (Opens Modal Popup) -->
                                                        <button type="button" class="btn-inline btn-assign-fleet" onclick="openAssignModal(<%= orderId %>, '#<%= orderNum %>')">
                                                            🚚 Assign Fleet
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                        <%
                                }
                                if (!hasOrders) {
                        %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-secondary); padding: 32px 0;">No delivery orders booked yet.</td>
                                    </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                        %>
                                <tr>
                                    <td colspan="5" style="color: var(--danger-color); text-align: center;">Error retrieving orders database.</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Book Order panel (Denise's AddDeliveryOrderServlet) -->
        <div class="glass-card">
            <h2 class="card-title">Book Delivery Order</h2>
            <form action="add-order" method="post">
                <div class="form-group">
                    <label for="recipientName">Recipient Name</label>
                    <input type="text" id="recipientName" name="recipientName" class="form-input" placeholder="e.g. Jane Smith" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="recipientPhone">Contact Phone</label>
                    <input type="text" id="recipientPhone" name="recipientPhone" class="form-input" placeholder="e.g. +63 917 123 4567" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="recipientAddress">Recipient Address</label>
                    <input type="text" id="recipientAddress" name="recipientAddress" class="form-input" placeholder="e.g. 123 Main St, Manila" required autocomplete="off">
                </div>

                <div class="form-group">
                    <label for="weight">Weight (kg)</label>
                    <input type="number" step="0.01" id="weight" name="weight" class="form-input" placeholder="e.g. 2.5" required autocomplete="off">
                </div>

                <button type="submit" class="btn-submit">Book Order</button>
            </form>
        </div>
    </div>

    <!-- Glassmorphism Modal Dialog for Fleet Assignment -->
    <div id="assignModal" class="modal-overlay">
        <div class="modal-card">
            <h3 class="modal-title" id="modalTitle">Assign Fleet & Dispatch</h3>
            <form action="OrderServlet" method="post">
                <input type="hidden" name="action" value="assign">
                <input type="hidden" id="modalOrderId" name="orderId" value="">

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="modalDriverSelect">Select Available Driver</label>
                    <select id="modalDriverSelect" name="driverId" class="form-input">
                        <option value="">-- Choose Driver --</option>
                        <%
                            try (Connection connModal = DatabaseConfig.getConnection();
                                 PreparedStatement psDrv = connModal.prepareStatement("SELECT * FROM drivers WHERE status = 'Available'");
                                 ResultSet rsDrv = psDrv.executeQuery()) {
                                while (rsDrv.next()) {
                        %>
                                    <option value="<%= rsDrv.getInt("driver_id") %>"><%= rsDrv.getString("name") %></option>
                        <%
                                }
                            } catch (Exception ignored) {}
                        %>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="modalVehicleSelect">Select Available Vehicle</label>
                    <select id="modalVehicleSelect" name="vehicleId" class="form-input">
                        <option value="">-- Choose Vehicle --</option>
                        <%
                            try (Connection connModal = DatabaseConfig.getConnection();
                                 PreparedStatement psVeh = connModal.prepareStatement("SELECT * FROM vehicles WHERE status = 'Available'");
                                 ResultSet rsVeh = psVeh.executeQuery()) {
                                while (rsVeh.next()) {
                        %>
                                    <option value="<%= rsVeh.getInt("vehicle_id") %>"><%= rsVeh.getString("plate_number") %> (<%= rsVeh.getString("vehicle_type") %>)</option>
                        <%
                                }
                            } catch (Exception ignored) {}
                        %>
                    </select>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeAssignModal()">Cancel</button>
                    <button type="submit" class="btn-submit" style="width: auto; margin-top: 0; padding: 10px 20px;">Confirm Assignment</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openAssignModal(orderId, orderNum) {
            document.getElementById('modalOrderId').value = orderId;
            document.getElementById('modalTitle').innerText = 'Assign Fleet to ' + orderNum;
            document.getElementById('assignModal').classList.add('active');
        }
        function closeAssignModal() {
            document.getElementById('assignModal').classList.remove('active');
        }
        // Close modal when clicking outside the card
        document.getElementById('assignModal').addEventListener('click', function(e) {
            if (e.target === this) closeAssignModal();
        });
    </script>
</body>
</html>
