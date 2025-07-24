# Custom Odoo Docker Setup

This repository contains a modified version of Odoo 18.0 with upgrade requirements removed from the Accounting addon.

## What's Modified

- **Accounting Addon**: Removed all `widget="upgrade_boolean"` requirements
- **No Enterprise Prompts**: All accounting features work without upgrade prompts
- **LGPL Compliant**: Modifications are fully compliant with Odoo's LGPL v3 license

## Features Made Available (No Upgrade Required)

- Currency Exchange Rate Updates
- Intrastat Statistics
- Batch Payments  
- SEPA Direct Debit
- SEPA Payments
- OCR Document Digitization
- Bank Statement Import (CSV, QIF, OFX, CAMT)
- Dynamic Financial Reports
- Budget Management

## Quick Start

### Using Pre-built Image from GitHub Container Registry

1. **Pull and run the latest image:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

2. **Access Odoo:**
   - URL: http://localhost:8069
   - Default database: odoo
   - Admin password: Set during first access

### Using Docker Compose (Local Development)

1. **Build and start services locally:**
   ```bash
   docker-compose up -d
   ```

2. **Access Odoo:**
   - URL: http://localhost:8069
   - Default database: odoo
   - Admin password: Set during first access

### Using Docker Build Scripts

**Linux/Mac:**
```bash
./build-docker.sh
docker-compose up -d
```

**Windows:**
```batch
build-docker.bat
docker-compose up -d
```

### Manual Docker Build

```bash
# Build the image
docker build -t odoo-custom:18.0-no-upgrade .

# Run with external PostgreSQL
docker run -d \
  -p 8069:8069 \
  -e HOST=your-postgres-host \
  -e USER=odoo \
  -e PASSWORD=your-password \
  --name odoo-custom \
  odoo-custom:18.0-no-upgrade
```

## Configuration

### Environment Variables

- `HOST`: PostgreSQL host (default: db)
- `PORT`: PostgreSQL port (default: 5432)
- `USER`: PostgreSQL user (default: odoo)
- `PASSWORD`: PostgreSQL password (default: odoo)
- `DATABASE`: Default database name (default: postgres)

### Volumes

- `/var/lib/odoo`: Odoo data directory
- `/var/log/odoo`: Odoo logs
- `/etc/odoo`: Odoo configuration files

## Development

### Adding Custom Addons

1. **Place addons in the addons directory:**
   ```
   addons/
   ├── account/          # Modified accounting addon
   └── your_custom_addon/
   ```

2. **Update Dockerfile to copy new addons:**
   ```dockerfile
   COPY addons/your_custom_addon /opt/odoo/addons/your_custom_addon
   RUN chown -R odoo:odoo /opt/odoo/addons/your_custom_addon
   ```

3. **Rebuild the image:**
   ```bash
   ./build-docker.sh
   ```

### Custom Configuration

Create a custom `odoo.conf` file and mount it:

```yaml
# In docker-compose.yml
volumes:
  - ./config/odoo.conf:/etc/odoo/odoo.conf
```

## Deployment

### Automated GitHub Actions Build

This repository includes GitHub Actions workflow that automatically:
- Builds the Docker image on every push
- Publishes to GitHub Container Registry (ghcr.io)
- Supports multi-platform builds (AMD64 + ARM64)
- Creates proper version tags

See `GITHUB_ACTIONS_SETUP.md` for detailed setup instructions.

### Production Deployment

1. **Use the pre-built image:**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

2. **Or deploy to your infrastructure:**
   ```bash
   docker pull ghcr.io/jacomarcon/odoo/odoo-custom:latest
   docker run -d -p 8069:8069 \
     -e HOST=your-db-host \
     -e USER=odoo \
     -e PASSWORD=your-password \
     ghcr.io/jacomarcon/odoo/odoo-custom:latest
   ```

### Manual Build and Push

1. **Build and tag for production:**
   ```bash
   ./build-docker.sh --push
   ```

### Security Considerations

- Change default PostgreSQL credentials
- Use secrets for sensitive environment variables
- Enable SSL/TLS for production
- Configure proper firewall rules
- Regular security updates

## License

This modified version maintains Odoo's original LGPL v3 license. See the LICENSE file for details.

## Support

This is a community modification. For Odoo core issues, refer to the official Odoo documentation. For modification-specific issues, please check the repository issues.
