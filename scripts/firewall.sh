# Install firewall
sudo apt install ufw -y
# Manage Firewall Rules
sudo ufw default deny incoming
sudo ufw allow 27015/udp
sudo ufw allow 7777/udp
sudo ufw allow 7778/udp
sudo ufw allow 27020/tcp
