#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "db-info command exists" test -f /usr/local/bin/db-info
check "db-info is executable" test -x /usr/local/bin/db-info
check "db-connect command exists" test -f /usr/local/bin/db-connect
check "db-connect is executable" test -x /usr/local/bin/db-connect

# Test that db-info runs without error
check "db-info runs successfully" db-info

# Test that db-connect help works
check "db-connect help works" db-connect --help

# Test sample scripts exist
check "postgres sample script exists" test -f /usr/local/share/database-scripts/postgres-sample.sql
check "mysql sample script exists" test -f /usr/local/share/database-scripts/mysql-sample.sql

echo "All database-tools tests passed!"