############################################
# Ark service                              #
############################################
# Copy ark.service
cp /home/jamie/ark-server/scripts/ark.service /etc/systemd/system/ark.service
# Install systemd
apt-get install systemd systemd-sysv

# Creating ARK Service
systemctl daemon-reload
# Enable systemd and stark ARK server
systemctl enable ark.service
systemctl start ark.service
