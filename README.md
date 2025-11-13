# 🎧 Audora — AI-Powered Global Music Streaming Platform

**Audora** is a next-generation music streaming platform built with microservices architecture, combining high-quality streaming, AI-driven personalization, and artist empowerment.

## 🚀 Features

- **JWT-based Authentication** with OAuth2 (Google, Apple)
- **Microservices Architecture** with Spring Boot & Spring Cloud
- **API Gateway** with rate limiting and JWT validation
- **Service Discovery** using Netflix Eureka
- **Distributed Caching** with Redis
- **Message Queue** with Apache Kafka
- **Full-text Search** with Elasticsearch
- **Monitoring** with Prometheus & Grafana
- **Containerization** with Docker
- **Database-per-Service** pattern with PostgreSQL

## 📦 Architecture

```
┌─────────────┐
│   Client    │
└──────┬──────┘
       │
┌──────▼──────────────┐
│   API Gateway       │  (Port 8080)
│   - Rate Limiting   │
│   - JWT Validation  │
└──────┬──────────────┘
       │
┌──────▼──────────────┐
│ Service Discovery   │  (Port 8761)
│   (Eureka Server)   │
└─────────────────────┘
       │
  ┌────┴────┬─────────┬──────────┐
  │         │         │          │
┌─▼───┐ ┌──▼──┐ ┌────▼────┐ ┌──▼────┐
│Auth │ │User │ │ Music   │ │Stream │
│8081 │ │8082 │ │Catalog  │ │ 8084  │
└─────┘ └─────┘ │  8083   │ └───────┘
                └─────────┘
```

## 🛠️ Tech Stack

### Backend
- **Java 21** with Spring Boot 3.2
- **Spring Cloud** (Gateway, Eureka, Config)
- **Spring Security** with JWT
- **Spring Data JPA** with Hibernate
- **PostgreSQL** (multiple databases)
- **Redis** for caching
- **Apache Kafka** for messaging
- **Elasticsearch** for search

### Infrastructure
- **Docker & Docker Compose**
- **Kubernetes** (for production)
- **AWS S3** (audio file storage)
- **CloudFront CDN**

### Monitoring
- **Prometheus** for metrics
- **Grafana** for visualization
- **Spring Boot Actuator**

## 📋 Prerequisites

- **Java 21** or higher
- **Maven 3.8+**
- **Docker & Docker Compose**
- **PostgreSQL 14+** (optional if using Docker)
- **Redis** (optional if using Docker)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/audora.git
cd audora
```

### 2. Set Up Environment Variables

```bash
cp .env.example .env
# Edit .env with your configuration
```

### 3. Start Infrastructure Services

```bash
docker-compose up -d postgres redis kafka elasticsearch
```

### 4. Initialize Database

```bash
psql -U postgres -f database/schema.sql
psql -U postgres -f database/seed_data.sql
```

### 5. Build All Services

```bash
mvn clean install -DskipTests
```

### 6. Start Services

#### Option A: Using Docker Compose (Recommended)

```bash
docker-compose up --build
```

#### Option B: Manual Start

```bash
# Terminal 1 - Service Discovery
cd audora-service-discovery
mvn spring-boot:run

# Terminal 2 - API Gateway
cd audora-api-gateway
mvn spring-boot:run

# Terminal 3 - Auth Service
cd audora-auth-service
mvn spring-boot:run
```

## 🔗 Service Endpoints

| Service | Port | URL |
|---------|------|-----|
| API Gateway | 8080 | http://localhost:8080 |
| Service Discovery | 8761 | http://localhost:8761 |
| Auth Service | 8081 | http://localhost:8081 |
| User Service | 8082 | http://localhost:8082 |
| Music Catalog | 8083 | http://localhost:8083 |
| Streaming Service | 8084 | http://localhost:8084 |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Kafka | 9092 | localhost:9092 |
| Elasticsearch | 9200 | http://localhost:9200 |
| Prometheus | 9090 | http://localhost:9090 |
| Grafana | 3001 | http://localhost:3001 |

## 📚 API Documentation

Once services are running, access Swagger UI:

- **Auth Service**: http://localhost:8081/swagger-ui.html
- **User Service**: http://localhost:8082/swagger-ui.html
- **Music Catalog**: http://localhost:8083/swagger-ui.html

## 🔐 Authentication Flow

### Register a New User

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "fullName": "John Doe"
  }'
```

### Login

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Use Access Token

```bash
curl -X GET http://localhost:8080/api/users/profile \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## 🏗️ Project Structure

```
audora/
├── audora-parent/              # Parent POM
├── audora-common/              # Shared DTOs, exceptions, utils
├── audora-service-discovery/   # Eureka Server
├── audora-api-gateway/         # API Gateway
├── audora-auth-service/        # Authentication & Authorization
├── audora-user-service/        # User profiles & playlists
├── audora-music-catalog-service/ # Songs, albums, artists
├── audora-streaming-service/   # Audio streaming
├── audora-upload-service/      # Music upload
├── audora-transcoding-service/ # Audio transcoding
├── audora-recommendation-service/ # AI recommendations
├── audora-analytics-service/   # Analytics & metrics
├── audora-payment-service/     # Stripe integration
├── audora-notification-service/ # Email/push notifications
├── audora-admin-service/       # Admin panel
├── database/                   # SQL schemas & migrations
├── monitoring/                 # Prometheus config
└── docker-compose.yml          # Docker orchestration
```

## 🧪 Testing

```bash
# Run all tests
mvn test

# Run specific service tests
cd audora-auth-service
mvn test

# Integration tests
mvn verify
```

## 📊 Monitoring

### Prometheus Metrics
- Navigate to http://localhost:9090
- Query examples:
  - `http_server_requests_seconds_count`
  - `jvm_memory_used_bytes`

### Grafana Dashboards
- Navigate to http://localhost:3001
- Login: admin / admin
- Import Spring Boot dashboard (ID: 10280)

## 🚢 Deployment

### Docker Build

```bash
# Build all services
docker-compose build

# Build specific service
docker build -t audora-auth-service ./audora-auth-service
```

### Kubernetes Deployment

```bash
kubectl apply -f k8s/
```

## 🔧 Configuration

### Application Properties

Each service has its own `application.yml`:
- Database connections
- Redis configuration
- Kafka topics
- JWT secrets
- OAuth2 credentials

### Environment Variables

Use `.env` file or export directly:
```bash
export JWT_SECRET=your-secret-key
export DB_PASSWORD=your-db-password
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 👥 Team

Built with ❤️ by the Audora Team

## 📞 Support

For support, email support@audora.app or join our Discord community.

---

**Happy Streaming! 🎵**
# audora
