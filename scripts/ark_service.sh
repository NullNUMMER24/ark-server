############################################
# Ark service                              #
############################################
# Creating ARK Service
echo "
[Unit]
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
ExecStart=/home/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=mumbly -server -log
ExecStop=killall -TERM srcds_linux
[Install]
WantedBy=multi-user.targeti
" >> /lib/systemd/system/ark.service
systemctl daemon-reload
# Enable systemd and stark ARK server
systemctl enable ark.service
systemctl start ark
