# Database CLI Tools

This feature installs popular database command-line tools and utilities for connecting to and managing various databases.

## Usage

```json
"features": {
    "ghcr.io/eviljoshspicer-features/database-tools:1": {
        "installPostgreSQL": true,
        "installMySQL": true,
        "installRedis": true,
        "installMongoDB": true,
        "installSQLite": true,
        "installDBeaver": false
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `installPostgreSQL` | boolean | `true` | Install PostgreSQL client tools |
| `installMySQL` | boolean | `true` | Install MySQL client tools |
| `installRedis` | boolean | `true` | Install Redis CLI tools |
| `installMongoDB` | boolean | `true` | Install MongoDB client tools |
| `installSQLite` | boolean | `true` | Install SQLite CLI tools |
| `installDBeaver` | boolean | `false` | Install DBeaver Community Edition |

## Installed Database Clients

### PostgreSQL (`psql`)
- Full-featured PostgreSQL client
- Supports all PostgreSQL features
- Interactive and scripting modes
- Built-in help and documentation

### MySQL (`mysql`)  
- Official MySQL command-line client
- Compatible with MariaDB
- Supports all MySQL features
- Batch and interactive modes

### Redis (`redis-cli`)
- Redis command-line interface
- Interactive and command modes
- Supports all Redis data types
- Monitoring and debugging features

### MongoDB (`mongosh`)
- Modern MongoDB shell
- JavaScript-based query interface
- Rich aggregation pipeline support
- Built-in help and auto-completion

### SQLite (`sqlite3`)
- Lightweight embedded database
- Perfect for development and testing
- No server setup required
- Full SQL support

### DBeaver (Optional)
- Professional database GUI tool
- Supports 80+ database types
- Visual query builder
- Data export/import capabilities

## Universal Database Connector

The feature includes a `db-connect` command that provides a unified interface:

```bash
# PostgreSQL
db-connect postgres -h localhost -U username -d database
db-connect pg -h host -p 5432 -U user -d db

# MySQL
db-connect mysql -h localhost -u username -p
db-connect mariadb -h host -P 3306 -u user

# Redis  
db-connect redis -h localhost -p 6379
db-connect redis -h host -a password

# MongoDB
db-connect mongo mongodb://localhost:27017/database
db-connect mongodb mongodb://user:pass@host:27017/db

# SQLite
db-connect sqlite database.db
db-connect sqlite /path/to/database.sqlite
```

## Environment Variables

Set these for default connection parameters:
```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=myuser
export DB_PASS=mypassword
export DB_NAME=mydatabase
```

## Quick Examples

### PostgreSQL
```bash
# Connect to database
psql -h localhost -U postgres -d myapp

# Run query from command line
psql -h localhost -U postgres -d myapp -c "SELECT * FROM users;"

# Execute SQL file
psql -h localhost -U postgres -d myapp -f script.sql

# Database backup
pg_dump -h localhost -U postgres myapp > backup.sql
```

### MySQL
```bash
# Connect to database  
mysql -h localhost -u root -p myapp

# Run query from command line
mysql -h localhost -u root -p -e "SELECT * FROM users;" myapp

# Execute SQL file
mysql -h localhost -u root -p myapp < script.sql

# Database backup
mysqldump -h localhost -u root -p myapp > backup.sql
```

### Redis
```bash
# Connect to Redis
redis-cli -h localhost -p 6379

# Set and get values
redis-cli SET mykey "Hello World"
redis-cli GET mykey

# Monitor commands
redis-cli MONITOR
```

### MongoDB
```bash
# Connect to MongoDB
mongosh mongodb://localhost:27017/myapp

# Run commands
mongosh --eval "db.users.find()"

# Execute JavaScript file
mongosh myapp script.js
```

### SQLite
```bash
# Open database
sqlite3 myapp.db

# Create table and insert data
sqlite3 myapp.db "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT);"
sqlite3 myapp.db "INSERT INTO users (name) VALUES ('John Doe');"

# Query data
sqlite3 myapp.db "SELECT * FROM users;"
```

## Sample Scripts

The feature includes sample SQL scripts in `/usr/local/share/database-scripts/`:

- `postgres-sample.sql` - Common PostgreSQL queries
- `mysql-sample.sql` - Common MySQL queries

## Database Connection Examples

### Local Development
```bash
# PostgreSQL with Docker
docker run -d --name postgres -e POSTGRES_PASSWORD=password -p 5432:5432 postgres
db-connect postgres -h localhost -U postgres

# MySQL with Docker  
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=password -p 3306:3306 mysql
db-connect mysql -h localhost -u root -p

# Redis with Docker
docker run -d --name redis -p 6379:6379 redis
db-connect redis -h localhost

# MongoDB with Docker
docker run -d --name mongo -p 27017:27017 mongo
db-connect mongo mongodb://localhost:27017
```

### Remote Connections
```bash
# SSL connections
db-connect postgres -h db.example.com -U user -d app --sslmode=require

# Connection with specific options
db-connect mysql -h db.example.com -u user -p --ssl-ca=ca.pem
```

Run `db-info` to see all installed database tools and connection examples!