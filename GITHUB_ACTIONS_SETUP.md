# GitHub Actions Docker Build Setup

This guide explains how to set up automated Docker image building and publishing to GitHub Container Registry.

## Prerequisites

1. **GitHub Repository**: Your code should be in a GitHub repository
2. **GitHub Packages**: Enabled for your repository (usually enabled by default)
3. **Permissions**: Admin access to the repository for settings

## Setup Instructions

### 1. Repository Settings

#### Enable GitHub Packages
1. Go to your repository on GitHub
2. Navigate to **Settings** → **Actions** → **General**
3. Under "Workflow permissions", ensure:
   - ✅ "Read and write permissions" is selected
   - ✅ "Allow GitHub Actions to create and approve pull requests" is checked

#### Package Visibility (Optional)
1. Go to **Settings** → **Actions** → **General**
2. Under "Package creation", you can set default visibility

### 2. Workflow Triggers

The GitHub Actions workflow (`.github/workflows/docker-build.yml`) triggers on:

- **Push to main or 18.0 branches**: Builds and pushes image
- **Pull Requests**: Builds image but doesn't push (testing)
- **Tags (v*.*.*)**: Creates versioned releases
- **Manual dispatch**: Run workflow manually from GitHub UI

### 3. Image Tags

The workflow automatically creates these tags:

```
ghcr.io/jacomarcon/odoo/odoo-custom:latest          # Latest from main branch
ghcr.io/jacomarcon/odoo/odoo-custom:18.0            # From 18.0 branch
ghcr.io/jacomarcon/odoo/odoo-custom:18.0-no-upgrade # Custom tag
ghcr.io/jacomarcon/odoo/odoo-custom:v1.0.0          # Version tags
ghcr.io/jacomarcon/odoo/odoo-custom:1.0             # Major.minor
ghcr.io/jacomarcon/odoo/odoo-custom:1               # Major only
```

### 4. Using the Built Images

#### Pull and Run
```bash
# Pull the latest image
docker pull ghcr.io/jacomarcon/odoo/odoo-custom:latest

# Run with docker-compose (production)
docker-compose -f docker-compose.prod.yml up -d

# Or run standalone
docker run -d -p 8069:8069 \
  -e HOST=your-db-host \
  -e USER=odoo \
  -e PASSWORD=your-password \
  ghcr.io/jacomarcon/odoo/odoo-custom:latest
```

#### Authentication (if repository is private)
```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Or use GitHub CLI
gh auth token | docker login ghcr.io -u USERNAME --password-stdin
```

### 5. Local Development vs Production

#### Local Development
```bash
# Build and run locally
docker-compose up -d
```

#### Production Deployment
```bash
# Use pre-built image from GitHub
docker-compose -f docker-compose.prod.yml up -d
```

### 6. Workflow Features

#### Multi-Platform Builds
- Builds for both `linux/amd64` and `linux/arm64`
- Compatible with Intel/AMD and ARM processors (including Apple Silicon)

#### Build Caching
- Uses GitHub Actions cache to speed up builds
- Caches Docker layers between builds

#### Security
- Uses GitHub's built-in `GITHUB_TOKEN`
- No additional secrets required
- Attestation for supply chain security

### 7. Monitoring Builds

#### GitHub Actions Tab
1. Go to your repository
2. Click **Actions** tab
3. View build status and logs

#### Package Registry
1. Go to your repository
2. Click **Packages** tab (or profile packages)
3. View published images and download stats

### 8. Troubleshooting

#### Build Failures
- Check the Actions tab for detailed logs
- Common issues:
  - Dockerfile syntax errors
  - Missing files in build context
  - Permission issues

#### Attestation Errors
If you see "Failed to get ID token" errors:
1. The workflow includes `continue-on-error: true` for attestations
2. Alternatively, use `docker-build-simple.yml` which doesn't include attestations
3. This is a newer GitHub feature that may not be available in all environments

#### Push Failures
- Verify repository permissions
- Check if package visibility allows pushes
- Ensure GITHUB_TOKEN has proper permissions

#### Permission Issues
If you get permission errors:
1. Go to Settings → Actions → General
2. Set "Workflow permissions" to "Read and write permissions"
3. Enable "Allow GitHub Actions to create and approve pull requests"

#### Image Pull Issues
```bash
# Check if image exists
docker manifest inspect ghcr.io/jacomarcon/odoo/odoo-custom:latest

# Check authentication
docker login ghcr.io
```

### 9. Customization

#### Change Registry or Image Name
Edit `.github/workflows/docker-build.yml`:
```yaml
env:
  REGISTRY: your-custom-registry.com
  IMAGE_NAME: your-org/your-image-name
```

#### Add Build Arguments
```yaml
- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    build-args: |
      BUILD_DATE=${{ steps.meta.outputs.labels['org.opencontainers.image.created'] }}
      VERSION=${{ steps.meta.outputs.labels['org.opencontainers.image.version'] }}
```

#### Custom Tags
Edit the `tags:` section in metadata extraction:
```yaml
tags: |
  type=ref,event=branch
  type=semver,pattern={{version}}
  type=raw,value=your-custom-tag
```

## Next Steps

1. **Push your code** to GitHub to trigger the first build
2. **Monitor the Actions tab** for build progress
3. **Test the image** using `docker-compose.prod.yml`
4. **Set up automatic deployments** using the built images

The workflow will automatically build and publish your custom Odoo image whenever you push changes, making it easy to deploy and distribute your modifications.
