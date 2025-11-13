# Audora Database Setup

## Overview
Audora uses PostgreSQL with separate databases for each microservice following the Database-per-Service pattern.

## Databases

1. **audora_auth** - Authentication and user credentials
2. **audora_users** - User profiles, playlists, and subscriptions
3. **audora_music** - Music catalog (artists, albums, songs)
4. **audora_analytics** - Play history and analytics data

## Setup Instructions

### Prerequisites
- PostgreSQL 14 or higher
- psql command-line tool

### 1. Create Databases

```bash
psql -U postgres -f schema.sql
```

### 2. Load Seed Data (Optional)

```bash
psql -U postgres -f seed_data.sql
```

### 3. Verify Setup

```bash
psql -U postgres -d audora_auth -c "\dt"
psql -U postgres -d audora_users -c "\dt"
psql -U postgres -d audora_music -c "\dt"
psql -U postgres -d audora_analytics -c "\dt"
```

## Database Connections

Each microservice connects to its respective database:

- **Auth Service**: `jdbc:postgresql://localhost:5432/audora_auth`
- **User Service**: `jdbc:postgresql://localhost:5432/audora_users`
- **Music Catalog Service**: `jdbc:postgresql://localhost:5432/audora_music`
- **Analytics Service**: `jdbc:postgresql://localhost:5432/audora_analytics`

## Environment Variables

Set the following environment variables for each service:

```bash
export DB_USERNAME=postgres
export DB_PASSWORD=your_password
```

## Schema Management

- The application uses Hibernate with `ddl-auto: update` for development
- For production, use Flyway or Liquibase for migrations
- Schema changes should be version-controlled

## Backup & Restore

### Backup All Databases
```bash
pg_dump -U postgres audora_auth > backup_auth.sql
pg_dump -U postgres audora_users > backup_users.sql
pg_dump -U postgres audora_music > backup_music.sql
pg_dump -U postgres audora_analytics > backup_analytics.sql
```

### Restore Database
```bash
psql -U postgres -d audora_auth < backup_auth.sql
```

## Performance Optimization

- All foreign keys have indexes
- Frequently queried columns have indexes
- Consider partitioning for large tables (play_history, user_activity)
- Use connection pooling in application.yml (HikariCP)

## Security

- Use strong passwords for database users
- Limit database user permissions per service
- Enable SSL for production database connections
- Regular security audits and updates
