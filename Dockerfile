FROM ubuntu:latest

# Update and install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y lib32gcc1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386 curl && \
    apt-get clean

# Install SteamCMD
RUN curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -v -C /usr/local/ -xz

# Create a steam user and switch to that user
RUN useradd -m steam
USER steam
WORKDIR /home/steam

# Download and install the ARK server
RUN /usr/local/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/server +app_update 376030 +quit

# Expose ports for ARK
EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp
EXPOSE 27020/tcp

# Start the ARK server
WORKDIR /home/steam/server/ShooterGame/Binaries/Linux
ENTRYPOINT ["./ShooterGameServer", "TheIsland?listen?SessionName=MyServer", "-server", "-log"]
