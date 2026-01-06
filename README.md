# Delta Chat Self-Hosted Server (Anti-Filtering Solution)

This project provides a professional, lightweight, and decentralized messaging backend based on SMTP/IMAP protocols. It is specifically optimized for high-restriction environments (like Iran's National Network), ensuring communication remains active even when international gateways are throttled.



## Key Features
- **Anti-Filtering**: Uses standard email protocols that are rarely blocked.
- **Privacy**: Supports End-to-End Encryption (E2EE) via Delta Chat clients.
- **Low Resource**: Runs efficiently on a 1-core CPU and 1GB RAM VPS.
- **Intranet Ready**: Works flawlessly over local IXP/Intranet when configured on local data centers (e.g., Afranet, ArvanCloud).

## Prerequisites
- A Linux VPS (Ubuntu 24.04 recommended).
- A registered domain name (e.g., `mshamsi.ir`).
- Ports open on your Firewall: 25, 143, 587, 993, 465, 80.

## Installation Steps

### Step 1: System Initialization
Prepare your fresh server and install Docker by running:
```bash
chmod +x init-vps.sh
./init-vps.sh
```

### Step 2: Configuration
1. Edit the `.env` file and set your domain:
   ```text
   MY_DOMAIN=yourdomain.ir
   ```
2. Start the infrastructure:
   ```bash
   chmod +x manage.sh
   ./manage.sh up
   ```

### Step 3: Account Management
Create your chat accounts to use in the app:
```bash
./manage.sh adduser user@yourdomain.ir your_secure_password
```

## Client Connection (Mobile App)
Download the **Delta Chat** app and use **Manual Setup** with these details:
- **IMAP Server**: mail.yourdomain.ir (Port: 143 / Security: None or STARTTLS)
- **SMTP Server**: mail.yourdomain.ir (Port: 587 / Security: None or STARTTLS)



## Security Note
This setup starts with `SSL_TYPE=none` for immediate connectivity. For production use, it is highly recommended to enable Let's Encrypt within the `docker-compose.yml` environment settings.

## License
MIT License - Feel free to use and distribute.
