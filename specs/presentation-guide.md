# Shopee Delivery System — Team Code Presentation Guide

This guide maps each team member's assigned feature directly to their corresponding source code files, exact line ranges, function signatures, and step-by-step presentation scripts.

---

## 🎤 1. RIMA BINALINBING MALAQUE — *Driver Management*

### Assigned Task: Add/Edit Driver & List Drivers

### Code File & Line Range Mapping

| Component | File Path | Line Range | Description |
| :--- | :--- | :--- | :--- |
| **Driver Controller (Add/Edit)** | `src/edu/iacademy/cselec05/pm_rima/servlet/DriverServlet.java` | `L21 - L67` | `doPost()`: Handles `action=add` and `action=edit` driver queries into MySQL. |
| **Driver Controller (Delete)** | `src/edu/iacademy/cselec05/pm_rima/servlet/DriverServlet.java` | `L69 - L101` | `doGet()`: Handles `action=delete` driver deletion. |
| **Driver Fleet Directory Table** | `WebContent/driver.jsp` | `L74 - L114` | Queries `SELECT * FROM drivers` and renders table rows. |
| **Driver Registration/Edit Form** | `WebContent/driver.jsp` | `L120 - L152` | Form inputs for `name`, `licenseNumber`, `phone`, `status`. |

### Presentation Script for Rima:
> *"My task was Driver Management. In `driver.jsp`, I built the Driver Directory UI showing all active fleet drivers with their license numbers and availability status. When a supervisor registers or updates a driver, the form submits to `DriverServlet.java`, where the `doPost()` method executes JDBC `INSERT INTO drivers` or `UPDATE drivers` queries."*

---

## 🎤 2. JOHNRAY LIBANTE DE FIESTA — *Fleet Vehicle Management*

### Assigned Task: Add/Edit Vehicle & Vehicle Catalog

### Code File & Line Range Mapping

| Component | File Path | Line Range | Description |
| :--- | :--- | :--- | :--- |
| **Vehicle Controller (Add/Edit)** | `src/edu/iacademy/cselec05/pm_rima/servlet/VehicleServlet.java` | `L20 - L78` | `doPost()`: Handles `action=add` and `action=edit` vehicle queries. |
| **Vehicle Controller (Delete)** | `src/edu/iacademy/cselec05/pm_rima/servlet/VehicleServlet.java` | `L80 - L112` | `doGet()`: Handles `action=delete` vehicle deletion. |
| **Vehicle Fleet Directory Table** | `WebContent/vehicle.jsp` | `L76 - L120` | Queries `SELECT * FROM vehicles` and displays fleet status badges. |
| **Vehicle Form Inputs** | `WebContent/vehicle.jsp` | `L125 - L172` | Form fields for `plateNumber`, `vehicleType`, `brand`, `model`, `capacity`, `status`. |

### Presentation Script for Johnray:
> *"My feature is Fleet Vehicle Management. On `vehicle.jsp`, I created the vehicle catalog which displays plate numbers, vehicle types, payload capacities in kg, and status badges (Available, In Use, Maintenance). The backend logic in `VehicleServlet.java` processes vehicle registrations and updates via JDBC statements targeting the `vehicles` database table."*

---

## 🎤 3. ARELLA DENISE INFANTE LONGNO — *Delivery Order Management*

### Assigned Task: Add Delivery Order & Set Delivery Order Status

### Code File & Line Range Mapping

| Component | File Path | Line Range | Description |
| :--- | :--- | :--- | :--- |
| **Create Shipment Controller** | `src/edu/iacademy/cselec05/pm_rima/servlet/AddDeliveryOrderServlet.java` | `L27 - L71` | `@WebServlet("/add-order")`: Accepts `recipientName`, `recipientPhone`, `recipientAddress`, `weight`, auto-generates tracking code `ORD-XXXXXX`, and inserts to MySQL. |
| **Update Status Controller** | `src/edu/iacademy/cselec05/pm_rima/servlet/SetOrderStatusServlet.java` | `L22 - L65` | `@WebServlet("/set-status")`: Updates order status (`Pending` ➔ `Assigned` ➔ `In Transit` ➔ `Delivered` / `Cancelled`). |
| **Shipment Entity Model** | `src/edu/iacademy/cselec05/pm_rima/model/DeliveryOrder.java` | `L5 - L114` | Domain model storing `id`, `recipientName`, `recipientAddress`, `recipientPhone`, `weight`, `status`. |
| **Booking Order Form** | `WebContent/orders.jsp` | `L174 - L198` | UI form submitting to `/add-order`. |
| **Status Dropdown Form** | `WebContent/orders.jsp` | `L126 - L146` | UI status change form submitting to `/set-status`. |

### Presentation Script for Denise:
> *"I implemented Delivery Order Management. In `orders.jsp`, users can book shipments with recipient names, contact numbers, addresses, and cargo weights. Booking submits to `AddDeliveryOrderServlet.java`, which auto-generates a tracking code `ORD-XXXXXX`, constructs a `DeliveryOrder` model, and saves it to MySQL. Supervisors can then update the status using `SetOrderStatusServlet.java`."*

---

## 🎤 4. KAREL MATTHIEU LLANTO LOGRO — *Architecture, Security & User Management*

### Assigned Task: Initial Setup, Authentication, User Provisioning & System Scaffolding

### Code File & Line Range Mapping

| Component | File Path | Line Range | Description |
| :--- | :--- | :--- | :--- |
| **Authentication Controller** | `src/edu/iacademy/cselec05/pm_rima/servlet/LoginServlet.java` | `L14 - L60` | Serves `/login` and `/` routes, authenticating user credentials into `HttpSession`. |
| **Password Security Utility** | `src/edu/iacademy/cselec05/pm_rima/util/PasswordUtil.java` | `L11 - L44` | Hashing with `hashPassword` (SHA-256 with secret salt) and `checkPassword` verification. |
| **Data Access & Auto-Seeding** | `src/edu/iacademy/cselec05/pm_rima/dao/UserDAO.java` | `L24 - L120` | `initTable()` executes `CREATE TABLE IF NOT EXISTS` for all tables and seeds default `admin` and `supervisor` accounts. |
| **Supervisor Registration** | `src/edu/iacademy/cselec05/pm_rima/servlet/RegisterServlet.java` | `L15 - L122` | Handles Admin registration of new Supervisor user accounts. |
| **Role-Based Dynamic View** | `WebContent/index.jsp` | `L74 - L139` | Enforces Role-Based Access Control (RBAC), rendering Admin Account Controls vs Supervisor Operations. |

### Presentation Script for Karel:
> *"I was responsible for Initial Setup, Security, User Management, and System Architecture. I implemented BCrypt password security in `PasswordUtil.java` and authentication handling in `LoginServlet.java`. In `UserDAO.java`, `initTable()` automatically sets up database tables and seeds default accounts upon server boot. Finally, in `index.jsp`, I implemented strict Role-Based Access Control separating Admin administrative tools from Supervisor operational controls."*
