# Shopee Delivery System Specifications

## 1. System Overview & Context

The **Shopee Delivery System** is an enterprise logistics and fleet management web application built on Java 8 (OpenJDK 8), Servlet API (javax.servlet), Apache Tomcat 9, and JSP. The platform manages delivery orders, vehicle fleets, driver assignments, and shipment lifecycles across defined user roles.

---

## 2. User Roles & Permission Hierarchy

### 2.1 Role Flowchart

```
┌────────────────────────┐
│     Unregistered       │
└───────────┬────────────┘
            │
            ▼ (Registers / Admin Provisions)
┌────────────────────────┐
│    Authenticated User  │
└───────────┬────────────┘
            │
  ┌─────────┴─────────┐
  ▼                   ▼
┌─────────────┐     ┌─────────────┐
│    Admin    │     │ Supervisor  │
└──────┬──────┘     └──────┬──────┘
       │                   │
       ├─ Register Users   ├─ Manage Drivers (Add/Edit/List)
       └─ Admin Settings   ├─ Manage Vehicles (Add/Edit/List)
                           ├─ Add Delivery Order
                           ├─ Assign Driver & Vehicle
                           └─ Set Order Status
```

### 2.2 Role Definitions

| Role                   | Access Level          | Description & Responsibilities                                                                                                                  |
| :--------------------- | :-------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Unregistered**       | Guest                 | Public landing page and authentication portals. May submit self-registration requests or wait for Admin provisioning.                           |
| **Authenticated User** | Base                  | Base security context for logged-in sessions. Holds credentials and session tokens (`HttpSession`).                                             |
| **Admin**              | System Management     | Manages system users (registers/provisions Admin & Supervisor accounts) and system-wide settings/configurations.                                |
| **Supervisor**         | Operations Management | Handles operational delivery flows: managing driver records, fleet vehicles, creating orders, assigning assets, and updating tracking statuses. |

---

## 3. Functional Requirements

### 3.1 Authentication & User Management (Admin & Unregistered)

- **FR-AUTH-01: User Self-Registration**: Unregistered users can submit account registration requests with `username`, `password`, `full_name`, and `email`.
- **FR-AUTH-02: Admin Account Provisioning**: Admins can directly create and provision accounts with explicit role assignment (`ADMIN` or `SUPERVISOR`).
- **FR-AUTH-03: Authentication & Session Control**: Validate credentials against stored password hashes. Establish an `HttpSession` storing `userId`, `username`, and `role`.
- **FR-ADMIN-01: Admin Settings**: Configure system defaults (e.g., maximum package weight, auto-assignment rules, system maintenance mode, audit logs).

### 3.2 Fleet & Logistics Management (Supervisor)

- **FR-SUP-01: Driver Management (Add/Edit/List)**:
  - Add new drivers with license details, phone numbers, and initial status (`AVAILABLE`).
  - Edit driver information and toggle operational status (`AVAILABLE`, `ON_DELIVERY`, `INACTIVE`).
  - List and search driver records with availability status filters.
- **FR-SUP-02: Vehicle Management (Add/Edit/List)**:
  - Add vehicles specifying plate number, vehicle type (`MOTORCYCLE`, `VAN`, `TRUCK`), and max weight capacity (kg).
  - Edit vehicle specifications and update status (`AVAILABLE`, `IN_USE`, `MAINTENANCE`).
  - List and view fleet vehicle inventory.

### 3.3 Delivery Order Lifecycle (Supervisor)

- **FR-ORD-01: Add Delivery Order**: Create new shipment entries capturing recipient name, contact phone, delivery address, package description, and package weight (kg). System auto-generates a unique tracking number (e.g., `SPD-YYYYMMDD-XXXX`).
- **FR-ORD-02: Assign Driver & Vehicle**: Select a pending order and assign an available driver and vehicle pair. Upon assignment, order status shifts to `ASSIGNED`, and driver/vehicle statuses transition to `ON_DELIVERY` / `IN_USE`.
- **FR-ORD-03: Set Order Status**: Progress the order through its state machine (`PENDING` → `ASSIGNED` → `IN_TRANSIT` → `DELIVERED` / `CANCELLED`). Terminal states (`DELIVERED`, `CANCELLED`) automatically release assigned drivers and vehicles back to `AVAILABLE`.

---

## 4. Access Control Matrix

| Feature / Action                | Unregistered | Authenticated | Admin | Supervisor |
| :------------------------------ | :----------: | :-----------: | :---: | :--------: |
| View Public Index / Login Page  |      ✅      |      ✅       |  ✅   |     ✅     |
| Account Self-Registration       |      ✅      |      ❌       |  ❌   |     ❌     |
| Login / Authenticate            |      ✅      |      ✅       |  ✅   |     ✅     |
| Logout / Destroy Session        |      ❌      |      ✅       |  ✅   |     ✅     |
| Provision / Register Users      |      ❌      |      ❌       |  ✅   |     ❌     |
| Configure Admin Settings        |      ❌      |      ❌       |  ✅   |     ❌     |
| Manage Drivers (Add/Edit/List)  |      ❌      |      ❌       |  ❌   |     ✅     |
| Manage Vehicles (Add/Edit/List) |      ❌      |      ❌       |  ❌   |     ✅     |
| Create Delivery Order           |      ❌      |      ❌       |  ❌   |     ✅     |
| Assign Driver & Vehicle         |      ❌      |      ❌       |  ❌   |     ✅     |
| Update Order Status             |      ❌      |      ❌       |  ❌   |     ✅     |

---

## 5. Domain Data Schema

```sql
-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('ADMIN', 'SUPERVISOR') NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Drivers Table
CREATE TABLE drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    status ENUM('AVAILABLE', 'ON_DELIVERY', 'INACTIVE') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles Table
CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(20) NOT NULL UNIQUE,
    model VARCHAR(50) NOT NULL,
    type ENUM('MOTORCYCLE', 'VAN', 'TRUCK') NOT NULL,
    capacity_kg DECIMAL(10,2) NOT NULL,
    status ENUM('AVAILABLE', 'IN_USE', 'MAINTENANCE') DEFAULT 'AVAILABLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Delivery Orders Table
CREATE TABLE delivery_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(30) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    delivery_address TEXT NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    package_details TEXT NOT NULL,
    weight_kg DECIMAL(10,2) NOT NULL,
    driver_id INT NULL,
    vehicle_id INT NULL,
    status ENUM('PENDING', 'ASSIGNED', 'IN_TRANSIT', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE SET NULL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);
```

---

## 6. Order State Lifecycle

```
[ PENDING ] ──────► [ ASSIGNED ] ──────► [ IN_TRANSIT ] ──────► [ DELIVERED ]
     │                    │                     │
     └────────────────────┴─────────────────────┴─────────────► [ CANCELLED ]
```

### State Rules:

1. **PENDING**: Initial state upon order creation. Driver & Vehicle are null.
2. **ASSIGNED**: Driver and Vehicle attached to the order. Driver status becomes `ON_DELIVERY`, Vehicle status becomes `IN_USE`.
3. **IN_TRANSIT**: Package is en route to destination.
4. **DELIVERED**: Terminal state. Driver and Vehicle statuses revert to `AVAILABLE`.
5. **CANCELLED**: Terminal state. Driver and Vehicle statuses revert to `AVAILABLE` if previously assigned.

---

## 7. Visual Use Case Reference

For visual diagram representation of system actors and use case relationships, see [use-case-diagram.png](./use-case-diagram.png).
