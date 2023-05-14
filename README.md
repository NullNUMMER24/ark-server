# ark-server
# Dockercommands
### Build the Image
´´´
docker build -t my-ark-server .
´´´
### Start the container
´´´
docker run -it -p 7777-7778:7777-7778/udp -p 27015:27015/udp -p 27020:27020/tcp my-ark-server
´´´