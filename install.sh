#################################################################################
# Prepare Host                                                                  #
#################################################################################
# Update the system
sudo apt-get update -y

#################################################################################
# Installing Dependencies                                                       #
#################################################################################
# Installing dependencies
sudo add-apt-repository multiverse -y
sudo apt install software-properties-common -y
sudo dpkg --add-architecture i386 
sudo apt update -y
sudo apt install lib32gcc-s1 steamcmd -y
sudo apt-get install lib32gcc-s1 -y

#################################################################################
# File editing                                                                  #
#################################################################################
echo "fs.file-max=100000" > /etc/sysctl.conf
sudo systemctl -p /etc/sysctl.conf
# Adding some stuf to extend the file limits
echo "* soft nofile 1000000" > /etc/security/limits.conf
echo "* hard nofile 1000000" > /etc/security/limits.conf

echo "session required pam_limits.so" > /etc/pam.d/common-session

ulimit -a

#################################################################################
# Adduser                                                                       #
#################################################################################
# Making a new steam User because it is a security risk to install steamcmd with root
useradd --create-home --shell /bin/bash --password 123 steam
su - steam
cd /home/steam
echo "user created----------------------------------------------------------------"

#################################################################################
# Installing SteamCMD                                                           #
#################################################################################
# Install steamcmd
sudo apt install steamcmd
echo "steamcmd installed"

# link the steamcmd executeable
sudo ln -s /usr/games/steamcmd /home/steam/steamcmd

# switch to steam user
su - steam
# make a SteamCMD directory
mkdir ~/Steam && cd ~/Steam
# Download and extract SteamCMD for Linux
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
# start SteamCMD
./steamcmd.sh

#################################################################################
# Download Server Files                                                         #
#################################################################################
# Download Ark Survival evolved Server
echo "login anonymous
force_install_dir "/home/steam/Steam"
app_update 376030 validate 
exit" | ./steamcmd.sh # Use ID: 445400 for Ark Survival of the fittest server
# Create a bash script to start the Server
echo "#! /bin/bash
./ShooterGameServer TheIsland?listen?SessionName=<server_name>?ServerPassword=<join_password>?ServerAdminPassword=<admin_password> -server -log" > /home/steam/Steam/server_start.sh
# Make it executeable
chmod +x /home/steam/Steam/server_start.sh
sudo /home/steam/Steam/server_start.sh

su -

#################################################################################
# Firewall                                                                      #
#################################################################################
## UFW ## 
echo " #!/bin/sh
if [[ $EUID -ne 0 ]]; then
    echo "This must be run as root"
    exit 1
fi
for port in 7777 7778 27015; do
    ufw allow $port/udp
done
#Uncomment the next if you want to open the default rcon port
#ufw allow 27020/tcp" > /home/steam/Steam/UFW.sh
# Make it executeable
chmod +x /home/steam/Steam/UFW.sh

#################################################################################
# Create Settings File                                                          #
#################################################################################
# Create the file
echo "[Unit]
Description=ARK: Survival Evolved dedicated server
Wants=network-online.target
After=syslog.target network.target nss-lookup.target network-online.target

[Service]
ExecStartPre=/home/steam/steamcmd +login anonymous +force_install_dir /home/steam/servers/ark +app_update 376030 +quit
ExecStart=/home/steam/servers/ark/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=NullNUMMER24 -server -log
WorkingDirectory=/home/steam/servers/ark/ShooterGame/Binaries/Linux
LimitNOFILE=100000
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s INT $MAINPID
User=steam
Group=steam

[ServerSettings]
ServerPVE=False
ServerCrosshair=True

[MessageOfTheDay]
Message=WELCOME_MESSAGE
Duration=20

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/ark-dedicated.service
#################################################################################
# Settings File Options                                                         #
#################################################################################
# Options         | Description
#-----------------+------------------------------------------------------
# SessionName     | Settting the Sessionname
# Message         | Customize the message when entering the Server
# ServerPVE       | Makes a PVP Server
# ServerCorsshair | Allow player using a Corsshair

#################################################################################
# Autostart the Server on Bootup                                                #
#################################################################################
# Install systemd
sudo apt-get install systemd systemd-sysv -y
# Activate auto startup for the ark server
sudo systemctl enable ark-dedicated
sudo systemctl start ark-dedicated