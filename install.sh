apt -y update && apt upgrade

add-apt-repository multiverse

dpkg --add-architecture i386

apt update

pt install lib32gcc1

apt install steamcmd

echo "fs.file-max=100000" > /etc/sysctl.conf

sysctl -p /etc/sysctl.conf

echo "* soft nofile 100000" > /etc/security/limits.conf
echo "* hard nofile 100000" > /etc/security/limits.conf

ulimit -n 100000

useradd --create-home --shell /bin/bash --password 123 steam

su - steam

ln -s /usr/games/steamcmd steamcmd

steamcmd +login anonymous +force_install_dir /home/steam/arkserver +app_update 376030 +quit

exit

echo "[Unit]
Description=ARK Survival Evolved
Wants=network-online.target
After=syslog.target network.target nss-lookup.target network-online.target

[Service]
Type=simple
Restart=on-failure
RestartSec=5
StartLimitInterval=60s
StartLimitBurst=3
User=steam
Group=steam
ExecStartPre=/home/steam/steamcmd +login anonymous +force_install_dir /home/steam/arkserver +app_update 376030 +quit
ExecStart=/home/steam/arkserver/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=ArkServer -server -log
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s INT $MAINPID
WorkingDirectory=/home/steam/arkserver/ShooterGame/Binaries/Linux
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target

- systemctl daemon-reload
- systemctl start ark
- systemctl status ark.service

- vi /home/steam/arkserver/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini
ServerPassword=YourServerPassword
ServerAdminPassword=YourServerAdminPassword"

systemctl restart ark