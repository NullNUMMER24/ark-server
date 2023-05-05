FROM ubuntu:latest

# Update the System
RUN apt-get update && sudo apt-get upgrade

# Install ufw
RUN apt-get install ufw 
RUN systemctl start ufw 
RUN systemctl enable ufw 

# Configure ufw
RUN ufw allow 27015/udp
RUN ufw allow 7777/udp
RUN ufw allow 7778/udp
RUN ufw allow 27020/tcp

# Increase the allowed number of open files
RUN echo “fs.file-max=100000” >> /etc/sysctl.conf && sysctl -p
RUN echo “* soft nofile 1000000” >> /etc/security/limits.conf
RUN echo “* hard nofile 1000000” >> /etc/security/limits.conf
RUN echo “session required pam_limits.so” >> /etc/pam.d/common-session

# Create the server directory
RUN mkdir server

# symlink from /usr/games/steamcmd to steamcmd
RUN ln -s /usr/games/steamcmd steamcmd

# RUN steamcmd
RUN steamcmd +login anonymous +force_install_dir /home/ark/server +app_update 445400 +quit

# COPY the service filem
COPY ark.service /lib/systemd/system/

# Start the ARK Service
RUN systemctl deamon-reload
RUN systemctl enable ark.service
CMD systemctl start ark

