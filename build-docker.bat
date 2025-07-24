@echo off
REM Build script for custom Odoo Docker image (Windows)

set IMAGE_NAME=odoo-custom
set TAG=18.0-no-upgrade
set REGISTRY=

echo Building custom Odoo Docker image...

echo Building %IMAGE_NAME%:%TAG%...
docker build -t %IMAGE_NAME%:%TAG% .

if %ERRORLEVEL% neq 0 (
    echo Build failed
    exit /b 1
)

echo Image built successfully: %IMAGE_NAME%:%TAG%

REM Tag as latest
docker tag %IMAGE_NAME%:%TAG% %IMAGE_NAME%:latest
echo Tagged as %IMAGE_NAME%:latest

echo Build complete!
echo To run with docker-compose: docker-compose up -d
echo To run standalone: docker run -d -p 8069:8069 --name odoo-custom %IMAGE_NAME%:%TAG%
