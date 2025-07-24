# Use the official Odoo image as base
FROM odoo:18.0

# Switch to root to install packages and copy files
USER root

# Copy the modified accounting addon
COPY addons/account /opt/odoo/addons/account

# Copy any other custom addons if needed
# COPY addons/your_custom_addon /opt/odoo/addons/your_custom_addon

# Set proper ownership for the odoo user
RUN chown -R odoo:odoo /opt/odoo/addons/account

# Switch back to odoo user for security
USER odoo

# Expose the default Odoo port
EXPOSE 8069

# Use the default entrypoint from the base image
# The base image already sets CMD ["odoo"]
