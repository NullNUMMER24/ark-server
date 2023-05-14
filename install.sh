#################################################################################
# Prepare Host                                                                  #
#################################################################################
# Make updates
sudo apt update -y && sudo apt upgrade -y
# Install Firewall
sudo apt install ufw -y
# Open Ports for Ark
sudo ufw allow 27015/udp #For the Steam server browser query
sudo ufw allow 7777/udp #For the game client
sudo ufw allow 7778/udp #For raw UDP socket
sudo ufw allow 27020/tcp #(Optional) For remote console (RCON) server access
# Add the multiverse repo and the i386 architecture
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt update
# Install dependencies for steamcmd
sudo apt install lib32gcc1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386
# Install steamcmd
sudo apt install steamcmd -y

#################################################################################
# Adjusting System Settings                                                     #
#################################################################################
# Increase the number of open files
echo "fs.file-max=100000" >> /etc/sysctl.conf && sysctl -p
# Update hard and soft file limits
echo "* soft nofile 1000000" >> /etc/security/limits.conf
echo "* hard nofile 1000000" >> /etc/security/limits.conf
# Enable PAM limits
echo "session required pam_limits.so" >> /etc/pam.d/common-session

#################################################################################
# Adduser                                                                       #
#################################################################################
# Making a new steam User because it is a security risk to install steamcmd with root
#useradd --create-home --shell /bin/bash --password 123 arkserver
# Switching to new user
#su - arkserver

#################################################################################
# Installing ARK server                                                                #
#################################################################################
# Create the server folder
mkdir server
# Create a symlink for "/usr/games/steamcmd" to steamcmd in the users home directory
ln -s /usr/games/steamcmd steamc
chmod +x steamc
# run steamcmd
steamcmd +login anonymous +force_install_dir /home/ark/server +app_update 376030 +quit

#################################################################################
# Creating ARK Service                                                          #
#################################################################################
# switching back to root user
#su -
# Create new systemd service
echo "[Unit]
Description=ARK Survival Evolved
[Service]
Type=simple
Restart=on-failure
RestartSec=5
StartLimitInterval=60s
StartLimitBurst=3
User=ark
Group=ark
ExecStartPre=/home/ark/steamcmd +login anonymous +force_install_dir /home/ark/server +app_update 376030 +quit
ExecStart=/home/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=NullNUMMER24 -server -log -crossplay
ExecStop=killall -TERM srcds_linux
[Install]
WantedBy=multi-user.target" >> /lib/systemd/system/ark.service
# apply changes
systemctl daemon-reload
# Enable new service
systemctl enable ark.service
systemctl start ark