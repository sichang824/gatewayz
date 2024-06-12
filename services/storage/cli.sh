#!/usr/bin/env bash

# shellcheck source=/dev/null
. ".env${DOT_ENV_TAG:-.local}"

TTY_CLIENT() {
    docker compose exec mysql mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "${@}"
}

CMD() {
    docker compose exec -T mysql mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "$1"
}

# Entry function to login to the MySQL database
# Usage: ./cli.sh login <USERNAME> <PASSWORD>
# Description: Logs in to the specified MySQL database using the provided credentials
entry_login() {
    local username="$1"
    local password="$2"

    if [[ -z "$username" || -z "$password" ]]; then
        echo "Error: Username or password not specified."
        echo "Usage: ./cli.sh login <USERNAME> <PASSWORD>"
        exit 1
    fi

    TTY_CLIENT -u"$username" -p"$password"
}

# Entry function to create a database in MySQL
# Usage: ./cli.sh create_db <DATABASE_NAME>
# Description: Creates a MySQL database with the provided name
entry_create_db() {
    local database=$1

    if [[ -z "$database" ]]; then
        echo "Error: No database name specified."
        echo "Usage: ./cli.sh create_db <DATABASE_NAME>"
        exit 1
    fi

    # Check if the database already exists
    existing_db=$(CMD "SHOW DATABASES LIKE '$database';")
    if [[ -n "$existing_db" ]]; then
        echo "Database '$database' already exists. Skipping creation."
        return
    fi

    CMD "CREATE DATABASE IF NOT EXISTS $database;"
    echo "Database '$database' created successfully."
}

# Entry function to connect to a MySQL database as root
# Usage: ./cli.sh client [<Options>]
# Description: Connects to the specified MySQL database using the root user
entry_client() {
    TTY_CLIENT "${@}"
}

# Entry function to create a user in MySQL and grant privileges
# Usage: ./cli.sh create_user <USERNAME> <PASSWORD>
# Description: Creates a MySQL user with the provided credentials
entry_create_user() {
    local username=$1
    password=$(openssl rand -base64 32)

    if [[ -z "$username" ]]; then
        echo "Error: No username specified."
        echo "Usage: ./cli.sh create_user <USERNAME>"
        exit 1
    fi

    # Check if the user already exists
    existing_user=$(CMD "SELECT user FROM mysql.user WHERE user = '$username';")
    if [[ -n "$existing_user" ]]; then
        echo "User '$username' already exists. Skipping creation."
        return
    fi

    echo "Creating user: $username"
    echo "Generated password: $password"
    echo "Please save this password as it will not be shown again."

    CMD "CREATE USER IF NOT EXISTS '$username'@'%' IDENTIFIED BY '$password';"
    echo "User '$username' created successfully."
}

# Entry function to delete a user in MySQL
# Usage: ./cli.sh delete_user <USERNAME>
# Description: Deletes a MySQL user with the provided name after confirmation
entry_delete_user() {
    local username=$1

    if [[ -z "$username" ]]; then
        echo "Error: No username specified."
        echo "Usage: ./cli.sh delete_user <USERNAME>"
        exit 1
    fi

    # Check if the user exists
    existing_user=$(CMD "SELECT user FROM mysql.user WHERE user = '$username';")
    if [[ -z "$existing_user" ]]; then
        echo "User '$username' does not exist. Skipping deletion."
        return
    fi

    read -rp "Are you sure you want to delete the user '$username'? Please type the username to confirm: " confirm_username
    if [[ "$confirm_username" != "$username" ]]; then
        echo "User deletion cancelled."
        return
    fi

    CMD "DROP USER '$username'@'%';"
    echo "User '$username' deleted successfully."
}

# Entry function to delete a database in MySQL
# Usage: ./cli.sh delete_db <DATABASE_NAME>
# Description: Deletes a MySQL database with the provided name after confirmation
entry_delete_db() {
    local database=$1

    if [[ -z "$database" ]]; then
        echo "Error: No database name specified."
        echo "Usage: ./cli.sh delete_db <DATABASE_NAME>"
        exit 1
    fi

    # Check if the database exists
    existing_db=$(CMD "SHOW DATABASES LIKE '$database';")
    if [[ -z "$existing_db" ]]; then
        echo "Database '$database' does not exist. Skipping deletion."
        return
    fi

    echo -e "Are you sure you want to delete the database '$database'?"
    read -rp "Please type the database name to confirm: " confirm_database
    if [[ "$confirm_database" != "$database" ]]; then
        echo "Database deletion cancelled."
        return
    fi

    CMD "DROP DATABASE $database;"
    echo "Database '$database' deleted successfully."
}

# Entry function to grant privileges to a user on a database in MySQL
# Usage: ./cli.sh grant <DATABASE_NAME> <USERNAME>
# Description: Grants all privileges on the specified database to the specified user
entry_grant() {
    local database=$1
    local username=$2

    if [[ -z "$database" ]]; then
        echo "Error: Database name not specified."
        echo "Usage: ./cli.sh grant <DATABASE_NAME> <USERNAME>"
        exit 1
    fi

    if [[ -z "$username" ]]; then
        echo "Error: Username not specified."
        echo "Usage: ./cli.sh grant <DATABASE_NAME> <USERNAME>"
        exit 1
    fi

    # Check if the database exists
    existing_db=$(CMD "SHOW DATABASES LIKE '$database';")
    if [[ -z "$existing_db" ]]; then
        echo "Database '$database' does not exist. Skipping privilege grant."
        return
    fi

    # Check if the user exists
    existing_user=$(CMD "SELECT user FROM mysql.user WHERE user = '$username';")
    if [[ -z "$existing_user" ]]; then
        echo "User '$username' does not exist. Skipping privilege grant."
        return
    fi

    echo "Granting privileges on database: $database to user: $username"
    CMD "GRANT ALL PRIVILEGES ON $database.* TO '$username'@'%'; FLUSH PRIVILEGES;"
    echo "Privileges granted. Displaying current privileges for user: $username on database: $database"
    CMD "SHOW GRANTS FOR '$username'@'%';"
}

# Main function example
# Usage: ./cli.sh <COMMAND>
# Description: Main function to execute the default behavior
function main() {
    echo "$1" # arguments are accessible through $1, $2,...
}

source "${AWESOME_SHELL_ROOT}/core/usage.sh" && usage "${@}"
