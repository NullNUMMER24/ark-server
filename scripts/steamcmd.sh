################################################
# Install SteamCMD                             #
################################################
# Add the multiverse repository
sudo add-apt-repository multiverse
# Add i386 architecture
sudo dpkg --add-architecture i386
# Update Repository
sudo apt update -y
# Install dependencies
sudo apt install lib32gcc1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386
# Install steamcmd package
sudo apt install steamcmd -y
# Create symlink
ln -s /usr/games/steamcmd steamcmd
