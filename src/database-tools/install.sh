#!/bin/sh
set -e

echo "Activating feature 'database-tools'"

# Update package lists
apt-get update

# Install base packages
apt-get install -y curl wget gnupg lsb-release

# Install PostgreSQL client tools if enabled
if [ "${INSTALLPOSTGRESQL}" = "true" ]; then
    echo "Installing PostgreSQL client tools..."
    apt-get install -y postgresql-client
fi

# Install MySQL client tools if enabled
if [ "${INSTALLMYSQL}" = "true" ]; then
    echo "Installing MySQL client tools..."
    apt-get install -y mysql-client
fi

# Install SQLite if enabled
if [ "${INSTALLSQLITE}" = "true" ]; then
    echo "Installing SQLite..."
    apt-get install -y sqlite3
fi

# Install Redis CLI if enabled
if [ "${INSTALLREDIS}" = "true" ]; then
    echo "Installing Redis CLI..."
    apt-get install -y redis-tools
fi

# Install MongoDB client tools if enabled
if [ "${INSTALLMONGODB}" = "true" ]; then
    echo "Installing MongoDB client tools..."
    
    # Add MongoDB repository
    wget -qO - https://www.mongodb.org/static/pgp/server-7.0.asc | apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
    
    apt-get update
    apt-get install -y mongodb-mongosh mongodb-org-tools
fi

# Install DBeaver if enabled
if [ "${INSTALLDBEAVER}" = "true" ]; then
    echo "Installing DBeaver Community Edition..."
    
    # Add DBeaver repository
    wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" | tee /etc/apt/sources.list.d/dbeaver.list
    
    apt-get update
    apt-get install -y dbeaver-ce
fi

# Create database connection helpers
cat > /usr/local/bin/db-connect << 'EOF'
#!/bin/bash
# Database connection helper script

show_help() {
    echo "Database Connection Helper"
    echo "========================="
    echo ""
    echo "Usage: db-connect <database_type> [options]"
    echo ""
    echo "Supported databases:"
    echo "  postgres, pg     - Connect to PostgreSQL"
    echo "  mysql, mariadb   - Connect to MySQL/MariaDB"
    echo "  redis           - Connect to Redis"
    echo "  mongo, mongodb  - Connect to MongoDB"
    echo "  sqlite          - Open SQLite database"
    echo ""
    echo "Examples:"
    echo "  db-connect postgres -h localhost -U username -d database"
    echo "  db-connect mysql -h localhost -u username -p"
    echo "  db-connect redis -h localhost -p 6379"
    echo "  db-connect mongo mongodb://localhost:27017/database"
    echo "  db-connect sqlite database.db"
    echo ""
    echo "Environment variables can be used:"
    echo "  DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME"
}

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

DB_TYPE="$1"
shift

case "$DB_TYPE" in
    "postgres"|"pg")
        if command -v psql > /dev/null 2>&1; then
            psql "$@"
        else
            echo "PostgreSQL client not installed"
            exit 1
        fi
        ;;
    "mysql"|"mariadb")
        if command -v mysql > /dev/null 2>&1; then
            mysql "$@"
        else
            echo "MySQL client not installed"
            exit 1
        fi
        ;;
    "redis")
        if command -v redis-cli > /dev/null 2>&1; then
            redis-cli "$@"
        else
            echo "Redis CLI not installed"
            exit 1
        fi
        ;;
    "mongo"|"mongodb")
        if command -v mongosh > /dev/null 2>&1; then
            mongosh "$@"
        elif command -v mongo > /dev/null 2>&1; then
            mongo "$@"
        else
            echo "MongoDB client not installed"
            exit 1
        fi
        ;;
    "sqlite")
        if command -v sqlite3 > /dev/null 2>&1; then
            sqlite3 "$@"
        else
            echo "SQLite not installed"
            exit 1
        fi
        ;;
    *)
        echo "Unsupported database type: $DB_TYPE"
        echo "Run 'db-connect --help' for supported types"
        exit 1
        ;;
esac
EOF

chmod +x /usr/local/bin/db-connect

# Create database info command
cat > /usr/local/bin/db-info << 'EOF'
#!/bin/sh
echo "🗄️  Database Tools Installed"
echo "============================"
echo ""

echo "📚 Available Database Clients:"
if command -v psql > /dev/null 2>&1; then
    echo "  ✅ PostgreSQL: $(psql --version | head -n1)"
fi
if command -v mysql > /dev/null 2>&1; then
    echo "  ✅ MySQL: $(mysql --version)"
fi
if command -v sqlite3 > /dev/null 2>&1; then
    echo "  ✅ SQLite: $(sqlite3 --version)"
fi
if command -v redis-cli > /dev/null 2>&1; then
    echo "  ✅ Redis: $(redis-cli --version)"
fi
if command -v mongosh > /dev/null 2>&1; then
    echo "  ✅ MongoDB Shell: $(mongosh --version | head -n1)"
elif command -v mongo > /dev/null 2>&1; then
    echo "  ✅ MongoDB: $(mongo --version | head -n1)"
fi
if command -v dbeaver > /dev/null 2>&1; then
    echo "  ✅ DBeaver Community Edition"
fi

echo ""
echo "🛠️  Available Commands:"
echo "  db-connect <type>  - Universal database connection helper"
echo "  psql              - PostgreSQL client"
echo "  mysql             - MySQL client"
echo "  sqlite3           - SQLite client"
echo "  redis-cli         - Redis client"
echo "  mongosh           - MongoDB shell"

echo ""
echo "💡 Connection Examples:"
echo "  db-connect postgres -h localhost -U username -d mydb"
echo "  db-connect mysql -h localhost -u username -p"
echo "  db-connect redis -h localhost -p 6379"
echo "  db-connect mongo mongodb://localhost:27017/mydb"
echo "  db-connect sqlite ./database.db"

echo ""
echo "🔐 Environment Variables:"
echo "  Set DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME for defaults"
EOF

chmod +x /usr/local/bin/db-info

# Create sample database scripts
mkdir -p /usr/local/share/database-scripts

# PostgreSQL sample
cat > /usr/local/share/database-scripts/postgres-sample.sql << 'EOF'
-- PostgreSQL Sample Queries
-- Connect with: db-connect postgres -h localhost -U username -d database

-- Show current database and user
SELECT current_database(), current_user;

-- List all databases
\l

-- List all tables in current database
\dt

-- Show table structure
\d table_name;

-- Show running queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';

-- Database size
SELECT pg_size_pretty(pg_database_size(current_database()));
EOF

# MySQL sample
cat > /usr/local/share/database-scripts/mysql-sample.sql << 'EOF'
-- MySQL Sample Queries
-- Connect with: db-connect mysql -h localhost -u username -p

-- Show current database and user
SELECT DATABASE(), USER();

-- List all databases
SHOW DATABASES;

-- List all tables in current database
SHOW TABLES;

-- Show table structure
DESCRIBE table_name;

-- Show running processes
SHOW PROCESSLIST;

-- Database size
SELECT 
    table_schema AS "Database",
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS "Size (MB)"
FROM information_schema.tables
GROUP BY table_schema;
EOF

echo "Database tools installed! Run 'db-info' for details."