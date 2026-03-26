# Hostel Room Allotment System

A full stack system designed to manage **real-world hostel room allocation workflows**, handling concurrent bookings, fairness constraints, and administrative control.

---

## Problem Statement

Manual hostel room allocation is often inefficient, error-prone, and unfair especially when multiple students attempt to book limited rooms simultaneously.  
This leads to **double bookings, inconsistent records, and lack of transparency** in allocation.

This project addresses these issues by building a system that ensures:
- **Consistent room allocation under concurrent requests**
- **Fair booking based on defined constraints**
- **Administrative control over room configurations**

---

## Key Features

- **Concurrent Booking Safety**  
  Prevents double allocation using transactional guarantees in MySQL.

- **Multi-user Booking Workflow**  
  Supports multiple users interacting with the system simultaneously.

- **Dynamic Room Configuration**  
  Handles different room types (AC/non-AC, varying capacities).

- **Admin Control Panel (Backend)**  
  Enables configuration of room partitions and allocation rules.

- **Constraint-based Allocation**  
  Enforces rules through relational schema design and backend logic.

---

## System Design

The system is built with a **layered architecture** to ensure maintainability and scalability:

- **API Layer (Express.js)**  
  Handles request routing and validation.

- **Service Layer**  
  Contains core business logic such as booking workflows and constraint enforcement.

- **Data Access Layer**  
  Manages database interactions with MySQL.

### Concurrency Handling

To handle simultaneous booking requests:
- Database transactions ensure **atomic operations**
- Constraints prevent inconsistent states (e.g., double booking)
- Structured test cases validate behavior under concurrent scenarios

---

## Tech Stack

- **Frontend:** Flutter  
- **Backend:** Node.js (Express.js)  
- **Database:** MySQL  
- **Architecture:** Clean Architecture (layered separation of concerns)

---

## Setup Instructions

```bash
# Clone the repository
git clone <your-repo-link>

# Backend setup
cd backend
npm install
npm start

# Frontend setup
cd frontend
flutter pub get
flutter run
