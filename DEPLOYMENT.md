# 🚀 Deployment Guide

## Production Deployment

This guide covers deploying the Messenger application to production.

## Backend Deployment

### Option 1: Using Linux Server

#### Prerequisites
- Linux server (Ubuntu 20.04 LTS recommended)
- Go 1.21+
- Git
- Nginx or Apache (optional, for reverse proxy)

#### Steps

1. **SSH into your server**
```bash
ssh user@your-server-ip
```

2. **Install Go**
```bash
wget https://go.dev/dl/go1.21.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

3. **Clone the repository**
```bash
git clone https://github.com/Artem2335/mail.git
cd mail/backend
```

4. **Build the application**
```bash
go mod download
go build -o messenger
```

5. **Run with systemd (recommended)**

Create `/etc/systemd/system/messenger.service`:
```ini
[Unit]
Description=Messenger Backend Service
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/user/mail/backend
ExecStart=/home/user/mail/backend/messenger
Restart=always
RestartSec=10
User=messenger
Group=messenger

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable messenger
sudo systemctl start messenger

# Check status
sudo systemctl status messenger
```

### Option 2: Using Docker

#### Dockerfile (Create in backend/)

```dockerfile
FROM golang:1.21-alpine as builder
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=1 GOOS=linux go build -o messenger .

FROM alpine:latest
RUN apk --no-cache add ca-certificates sqlite
WORKDIR /app
COPY --from=builder /app/messenger .
EXPOSE 8080
CMD ["./messenger"]
```

#### Build and run
```bash
docker build -t messenger-backend .
docker run -p 8080:8080 -v uploads:/app/uploads messenger-backend
```

### Option 3: Using Heroku

1. **Install Heroku CLI**
```bash
curl https://cli-assets.heroku.com/install.sh | sh
```

2. **Create Procfile** in backend/
```
web: ./messenger
```

3. **Deploy**
```bash
heroku create your-app-name
git push heroku main
```

### IMPORTANT: Production Security Settings

1. **Change JWT Secret** in `handlers/auth.go`:
```go
var jwtSecret = "your-secure-random-string-generate-with-openssl"
```

2. **Update CORS settings** in `main.go` with your frontend URL

3. **Set environment variables**
```bash
JWT_SECRET=your-secret
DB_PATH=/var/lib/messenger/messenger.db
ALLOWED_ORIGINS=https://yourdomain.com
```

4. **Use HTTPS** - Get SSL certificate from Let's Encrypt

## Frontend Deployment

### Option 1: Google Play Store

1. **Create Google Play account** - $25 one-time fee

2. **Generate signed APK**
```bash
cd frontend
flutter build apk --release --split-per-abi
```

3. **Create app bundle for Play Store**
```bash
flutter build appbundle --release
```

4. **Upload to Google Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app
   - Upload app bundle
   - Fill in app details, screenshots, description
   - Submit for review

### Option 2: TestFlight (iOS)

1. **Create Apple Developer account** - $99/year

2. **Build iOS app**
```bash
cd frontend
flutter build ios --release
```

3. **Archive and upload via Xcode**
   - Open `frontend/ios/Runner.xcworkspace`
   - Select Generic iOS Device
   - Product → Archive
   - Distribute App → TestFlight

### Option 3: Distribute APK Directly

1. **Build release APK**
```bash
flutter build apk --release
```

2. **Upload to cloud storage** (Firebase, AWS S3, etc.)

3. **Share download link** with users

## Reverse Proxy Setup (Nginx)

### nginx.conf
```nginx
server {
    listen 443 ssl http2;
    server_name api.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /uploads {
        alias /home/user/mail/backend/uploads;
    }
}
```

## Database Backup

### Automated Daily Backup

```bash
#!/bin/bash
BACKUP_DIR="/backups/messenger"
DB_PATH="/home/user/mail/backend/messenger.db"
DATE=$(date +%Y%m%d_%H%M%S)

cp "$DB_PATH" "$BACKUP_DIR/messenger_$DATE.db"

# Keep only last 30 backups
find $BACKUP_DIR -type f -name "*.db" -mtime +30 -delete
```

Add to crontab:
```bash
0 2 * * * /home/user/backup.sh  # Daily at 2 AM
```

## Monitoring & Logging

### Check logs
```bash
sudo journalctl -u messenger -f
```

### Monitor disk usage
```bash
du -sh /home/user/mail/backend/uploads/
```

### Monitor database size
```bash
ls -lh /home/user/mail/backend/messenger.db
```

## Performance Optimization

1. **Enable database indexing** - Already configured in models
2. **Use Redis for caching** - Optional, for future optimization
3. **Implement rate limiting** - Add middleware for spam prevention
4. **Compress API responses** - Enable gzip in Gin

## Troubleshooting

### High CPU usage
- Check active connections: `lsof -i :8080`
- Review recent logs: `sudo journalctl -u messenger -n 100`

### Database locked
- Ensure only one service instance
- Check file permissions: `ls -l messenger.db`

### Out of disk space
- Clean old uploaded files
- Compress backups
- Archive old messages

## Scaling

### Horizontal Scaling
1. Deploy multiple backend instances
2. Use load balancer (Nginx, HAProxy)
3. Share database (PostgreSQL for multiple instances)

### Vertical Scaling
1. Upgrade server RAM
2. Use faster storage (SSD)
3. Optimize database queries

## Maintenance

### Regular tasks
- 📄 Review logs weekly
- 🖥️ Backup database daily
- 🔍 Monitor disk usage
- 🤓 Update dependencies monthly
- 🔀 Rotate logs

### Security updates
- Update Go version quarterly
- Update Flutter version quarterly
- Review security advisories

## Support

For deployment issues:
1. Check backend logs
2. Verify firewall rules
3. Test API endpoints with curl
4. Check database connectivity

---

**Production deployment complete! 👏**
