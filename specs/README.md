# Shopee Delivery System Specifications & Architecture Documentation

Welcome to the specification repository for the **Shopee Delivery System**.

## Documents & Assets

- 📄 [System Specifications (`specs.md`)](./specs.md)
  - Detailed system requirements, user role hierarchy, access control matrix, database schema, functional requirements, and order state lifecycle.
- 🖼️ [Use Case Diagram (`use-case-diagram.png`)](./use-case-diagram.png)
  - Architectural Use Case Diagram depicting interactions between Unregistered Guests, Authenticated Users, Admins, and Supervisors.

## Quick Role Overview

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
