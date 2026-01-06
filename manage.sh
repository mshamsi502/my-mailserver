#!/bin/bash

# ==============================================================================
# Script Name: manage.sh (Auto-Cleanup Version)
# ==============================================================================

CONTAINER_NAME="deltachat_server"
NETWORK_NAME="deltachat_network"

usage() {
    echo "Usage: $0 {up|down|adduser|list|logs|restart}"
    exit 1
}

case "$1" in
    up)
        echo "[INFO] Cleaning up old containers and networks to prevent conflicts..."
        # Stop and remove any container using our name or ports
        docker rm -f $CONTAINER_NAME 2>/dev/null
        docker rm -f mailserver 2>/dev/null # For the old ghost container you have
        
        # Remove the conflicting network
        docker network rm $NETWORK_NAME 2>/dev/null
        
        echo "[INFO] Deploying Delta Chat infrastructure..."
        docker compose up -d
        ;;
        
    down)
        echo "[INFO] Shutting down infrastructure..."
        docker compose down
        ;;
        
    adduser)
        if [ -z "$2" ] || [ -z "$3" ]; then echo "Usage: $0 adduser email pass"; exit 1; fi
        docker exec -it $CONTAINER_NAME setup email add "$2" "$3"
        ;;
        
    list)
        docker exec -it $CONTAINER_NAME setup email list
        ;;
        
    logs)
        docker logs -f $CONTAINER_NAME
        ;;
        
    restart)
        docker compose restart
        ;;
        
    *)
        usage
        ;;
esac
