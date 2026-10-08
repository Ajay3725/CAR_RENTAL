# Car Rental - Spring Boot Backend

A complete Java Spring Boot backend for the Car Rental web application, connected to MySQL.

---

## 📁 Project Structure

```
backend/
├── pom.xml                               # Maven project dependencies & build configuration
├── run.bat                               # Windows Command Prompt 1-click startup script
├── run.ps1                               # Windows PowerShell startup script
├── mvnw / mvnw.cmd                       # Embedded Maven wrapper (no global Maven needed)
├── .mvn/wrapper/                         # Maven wrapper binary & properties
└── src/
    └── main/
        ├── java/com/carrental/backend/
        │   ├── BackendApplication.java   # Spring Boot Main Entry Point
        │   ├── config/
        │   │   └── CorsConfig.java       # Global CORS (Allows Next.js frontend)
        │   ├── controller/
        │   │   ├── AuthController.java   # Login, Signup, Users endpoints
        │   │   ├── CarController.java    # Cars CRUD endpoints (User & Admin)
        │   │   └── BookingController.java# Bookings creation & confirmation
        │   ├── dto/                      # Data Transfer Objects (Requests & Responses)
        │   ├── model/
        │   │   ├── User.java             # Entity for `users` table
        │   │   ├── Car.java              # Entity for `cars` table
        │   │   └── Booking.java          # Entity for `bookings` table
        │   ├── repository/               # Spring Data JPA Repositories
        │   ├── service/                  # Business logic services
        │   └── util/
        │       └── PasswordUtil.java     # Scrypt hashing compatible with existing data
        └── resources/
            └── application.properties    # MySQL & Server configuration
```

---

## ⚙️ Database Configuration

Configured in `src/main/resources/application.properties`:

```properties
server.port=8080

spring.datasource.url=jdbc:mysql://localhost:3306/car_rental?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=car_rental_app
spring.datasource.password=1234
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

> **Note:** If you want to connect using your `root` MySQL user instead, simply change `spring.datasource.username=root` and `spring.datasource.password=YOUR_ROOT_PASSWORD`.

---

## 🚀 How to Run the Backend

You can run the backend using any of the following methods:

### Method 1: Using the Startup Scripts
From the `backend` folder, run:

**Command Prompt / CMD:**
```cmd
run.bat
```

**PowerShell:**
```powershell
.\run.ps1
```

### Method 2: Using the Maven Wrapper directly
```powershell
$env:JAVA_HOME = "C:\Program Files\Java\jdk-24"
.\mvnw.cmd spring-boot:run
```

### Method 3: In VS Code / IntelliJ IDEA
1. Open the `backend` folder in VS Code or IntelliJ.
2. Run `BackendApplication.java`.

---

## 📡 REST API Endpoints

The backend runs on **`http://localhost:8080`**.

### 1. Authentication (`/api` / `/api/auth`)

#### User / Admin Login
- **Endpoint:** `POST /api/login` (or `/api/auth/login`)
- **Body:**
```json
{
  "username": "admin",
  "password": "123"
}
```
- **Response (200 OK):**
```json
{
  "success": true,
  "user": {
    "id": 31,
    "username": "admin",
    "role": "admin"
  }
}
```

#### User Signup
- **Endpoint:** `POST /api/signup` (or `/api/auth/signup`)
- **Body:**
```json
{
  "username": "newuser",
  "password": "password123",
  "role": "user"
}
```
- **Response (201 Created):**
```json
{
  "success": true,
  "user": {
    "id": 42,
    "username": "newuser",
    "role": "user"
  }
}
```

#### List All Users
- **Endpoint:** `GET /api/users`
- Returns all users registered in the `users` table with password hashes hidden.

---

### 2. Cars Management (`/api/cars` / `/api/admin/cars`)

#### Get All Cars
- **Endpoint:** `GET /api/cars` (or `/api/admin/cars`)
- **Response:** List of cars with price, mileage, seats, rating, and image URL.

#### Add a New Car (Admin)
- **Endpoint:** `POST /api/admin/cars/add` (or `POST /api/cars`)
- **Body:**
```json
{
  "name": "Tata Safari",
  "price": 3500.00,
  "image": "/Tata Nexon.jpg",
  "mileage": "18 KM",
  "seats": "7",
  "rating": "4.8"
}
```

#### Update Car (Admin)
- **Endpoint:** `PUT /api/admin/cars/update` (or `PUT /api/cars`)
- **Body:**
```json
{
  "id": 61,
  "name": "Hyundai Creta",
  "price": 3200.00,
  "image": "/hyundai.avif",
  "mileage": "20 KM",
  "seats": "5",
  "rating": "4.7"
}
```

#### Delete Car (Admin)
- **Endpoint:** `DELETE /api/admin/cars/delete`
- **Body:**
```json
{
  "id": 61
}
```
*(Also supports `DELETE /api/cars/{id}`)*

---

### 3. Bookings (`/api/bookings` / `/api/booking`)

#### Create a Booking
- **Endpoint:** `POST /api/bookings` (or `POST /api/booking`)
- **Body:**
```json
{
  "userId": 32,
  "name": "Honda City",
  "price": 2000,
  "mileage": "19 KM",
  "seats": "5",
  "rating": "4.4",
  "image": "/Honda.jpg"
}
```
- **Response:**
```json
{
  "success": true,
  "message": "Booking stored successfully",
  "bookingId": 106
}
```

#### Confirm Payment & Booking Dates
- **Endpoint:** `PUT /api/booking`
- **Body:**
```json
{
  "bookingId": 106,
  "total": 2000,
  "payment": "UPI",
  "pickupDate": "2026-10-10",
  "returnDate": "2026-10-12"
}
```
- **Response:**
```json
{
  "success": true,
  "message": "Booking confirmed successfully."
}
```

#### View All Bookings
- **Endpoint:** `GET /api/bookings`
- **Endpoint for specific user:** `GET /api/bookings/user/{userId}`

---

## 🔗 Connecting Frontend (Next.js) to Spring Boot

You can connect your Next.js frontend (`version` folder) to this Spring Boot backend in either of two easy ways:

### Option A: Automatic Proxy in `version/next.config.ts` (Recommended)
Add a rewrite in [`version/next.config.ts`](file:///c:/Users/jagat/.vscode/orginalproject0json/version/next.config.ts):
```ts
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: "/api/:path*",
        destination: "http://localhost:8080/api/:path*",
      },
    ];
  },
};

export default nextConfig;
```
This routes all frontend `/api/*` calls directly to Spring Boot without changing any component code!

### Option B: Direct Fetch Calls
Call `http://localhost:8080/api/...` directly from your frontend components (CORS is already configured and enabled for all `localhost` origins).

