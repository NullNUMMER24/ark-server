# Install updates
sudo apt get update -y
sudo apt get upgrade -y
# Install dependencies
sudo apt-get install lib32gcc1-s1
# Increasing the allowed number of open files
echo "fs.file-max=100000" >> /etc/sysctl.conf && sysctl -p                                                                                                                                                                                # Update the hard and soft file limits
echo "* soft nofile 1000001" >> /etc/security/limits.conf
echo "* hard nofile 1000000" >> /etc/security/limits.conf
# Enable PAM limits
echo "session required pam_limits.so" >> /etc/pam.d/common-session
