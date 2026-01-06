#!/bin/bash

# ==============================================================================
# Script Name: manage.sh
# Description: Management utility for Delta Chat accounts and server status.
# ==============================================================================

CONTAINER="deltachat_server"

usage() {
    echo "Usage: $0 {up|down|adduser|deluser|list|logs|restart}"
    echo "  up      : Start the Delta Chat server infrastructure"
    echo "  down    : Stop and remove server containers"
    echo "  adduser : Create a chat account (Usage: ./manage.sh adduser user@domain.com pass)"
    echo "  deluser : Delete a chat account"
    echo "  list    : List all registered chat accounts"
    echo "  logs    : Stream real-time mail logs"
    echo "  restart : Restart the server container"
    exit 1
}

case "$1" in
    up)
        echo "[INFO] Deploying Delta Chat infrastructure..."
        docker-compose up -d
        ;;
    down)
        echo "[INFO] Shutting down infrastructure..."
        docker-compose down
        ;;
    adduser)
        if [ -z "$2" ] || [ -z "$3" ]; then usage; fi
        echo "[INFO] Creating account: $2"
        docker exec -it $CONTAINER setup email add "$2" "$3"
        ;;
    deluser)
        if [ -z "$2" ]; then usage; fi
        docker exec -it $CONTAINER setup email del "$2"
        ;;
    list)
        docker exec -it $CONTAINER setup email list
        ;;
    logs)
        docker logs -f $CONTAINER
        ;;
    restart)
        docker-compose restart
        ;;
    *)
        usage
        ;;
esac