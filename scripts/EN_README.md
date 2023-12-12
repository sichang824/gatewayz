## Bash Deployment Script

## Overview

This Bash script streamlines the deployment, management, and upgrading of a Dockerized application. It includes functionalities for pulling the latest code, starting, stopping, restarting the application, and checking its status. The script now features improved configurability by allowing users to specify the Git branch as a configuration variable.

## Prerequisites

Before using this script, ensure that the following prerequisites are met:

- **Git:** Ensure Git is installed on your system.
- **Docker:** Make sure Docker is installed and configured.

## Configuration

In the script, you can find a configuration section where you can customize certain variables according to your project needs:

```shell
# Configuration
BRANCH_NAME="main"  # Default branch name, modify as needed
```

Adjust the `BRANCH_NAME` variable to match the default branch used in your project.

## Usage

### Running the Script

```shell
./deploy.sh [action]
```

Replace `[action]` with one of the following:

- `start`: Start the application.
- `stop`: Stop the application.
- `restart`: Restart the application.
- `check`: Check the status of the application.
- `upgrade`: Upgrade the application by pulling the latest code.

### Customization

- The script allows customization of the default branch by modifying the `BRANCH_NAME` variable in the configuration section.

- Ensure that your project structure and `.env` file are appropriately set up for environment variable loading.

- You can customize the script further based on your specific project requirements.

## Important Note

- Ensure the script has executable permissions. If not, run `chmod +x deploy.sh` to grant execution permissions.

- For the `check` action, you can specify the container name as an optional argument. If not provided, the script will use the default container name.

## Examples

### Start the Application

```shell
./deploy.sh start
```

### Stop the Application

```shell
./deploy.sh stop
```

### Restart the Application

```shell
./deploy.sh restart
```

### Check Application Status

```shell
./deploy.sh check [optional_container_name]
```

### Upgrade the Application

```shell
./deploy.sh upgrade
```

## License

This script is provided under the [MIT License](https://chat.openai.com/share/LICENSE).
