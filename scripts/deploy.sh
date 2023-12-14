#!/usr/bin/env bash
set -e
# Determine the directory where the script is located
CURRENT_DIR="$(dirname "$(readlink -f "$0")")"

pull_code() {
    builtin cd "${CURRENT_DIR}/../"
    git fetch origin "${BRANCH_NAME}"
    git reset --hard HEAD
    git submodule sync
    git submodule update --init --recursive
    git add .
    git stash
    builtin cd - >/dev/null
}

cd() {
    builtin cd "$@"
    if [ -f .env ]; then
        set -o allexport && source .env && set +o allexport
    fi
}

cd "${CURRENT_DIR}"
if [[ ! "${COMPOSE_DIR}" =~ ^/ ]]; then
    COMPOSE_DIR="${CURRENT_DIR}/${COMPOSE_DIR}"
fi

exec_in_compose_dir() {
    local cmd=("$@")
    builtin cd "${COMPOSE_DIR}"
    builtin cd "${COMPOSE_DIR}" && "${cmd[@]}"
    builtin cd - >/dev/null
}

print_color() {
    local color_code=""

    case "$1" in
    "succ")
        color_code="\e[36m" # Cyan for information
        ;;
    "info")
        color_code=""
        ;;
    "warn")
        color_code="\e[33m" # Yellow for warning
        ;;
    "error")
        color_code="\e[31m" # Red for error
        ;;
    *)
        color_code="" # Default color
        ;;
    esac

    shift                            # Remove the first argument
    echo -e "${color_code} $* \e[0m" # Print with color and reset to default
}

upgrade_application() {
    pull_code
}

check_application() {
    local name=$1
    builtin cd "$COMPOSE_DIR"

    container_count=$(docker-compose ps -q "$name" | wc -l)

    if [ "$container_count" -eq 1 ]; then
        print_color "succ" "The application '$name' is running."
        return 0
    elif [ "$container_count" -eq 0 ]; then
        print_color "error" "Error: No instances of the application '$name' are running."
        return 1
    else
        print_color "error" "Error: Multiple instances of the application '$name' are running. Expected 1."
        return 1
    fi
}

start_application() {
    echo "Starting the application..."
    exec_in_compose_dir docker-compose --profile "$COMPOSE_PROFILE" up -d --build
}

stop_application() {
    echo "Stopping the application..."
    exec_in_compose_dir docker-compose --profile "$COMPOSE_PROFILE" down
}

restart_application() {
    echo "Restarting the application..."
    if check_application "${CONTAINER_NAME}"; then
        exec_in_compose_dir docker-compose --profile "$COMPOSE_PROFILE" up -d --force-recreate --build
    else
        start_application
    fi
}

actions=("start" "stop" "restart" "check" "upgrade")

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [${actions[*]}]"
    exit 1
fi

action=$1

case $action in
start)
    start_application
    ;;
stop)
    stop_application
    ;;
restart)
    restart_application
    ;;
check)
    check_application "${2:-$CONTAINER_NAME}"
    ;;
upgrade)
    upgrade_application
    ;;
*)
    echo "Invalid action. Please use [${actions[*]}]"
    exit 1
    ;;
esac

exit 0
