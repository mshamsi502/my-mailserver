
# Self-Hosted Delta Chat Server (Anti-Filtering)

Automated deployment of a private messaging infrastructure. This setup is designed for high-restriction networks, ensuring persistent communication.

## Quick Installation

### 1. Initialize Server
The script automatically detects your VPS hostname and configures the environment.
```bash
chmod +x init-vps.sh
./init-vps.sh
```

### 2. Configure Domain
Set your domain in the `.env` file:
```text
MY_DOMAIN=mshamsi.ir
```

### 3. Start Server
```bash
chmod +x manage.sh
./manage.sh up
```

### 4. Create Account
```bash
./manage.sh adduser user@yourdomain.ir your_password
```

## Connection Details
- **IMAP**: mail.yourdomain.ir (Port 143)
- **SMTP**: mail.yourdomain.ir (Port 587)
