## Ubuntu Server Setup  (as of 23.10 Manic)
Application server for hosting Node.JS (React) apps.
1) Install Node

````
sudo apt-get update
sudo apt-get install -y curl apt-transport-https ca-certificates
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs build-essential
sudo apt-get install -y nodejs build-essential
````


2) Install nginx
````
sudo apt-get install nginx
````

3) Install Passenger
 
````
# Install our PGP key 
curl https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/phusion.gpg >/dev/null

# Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger mantic main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

# Install Passenger + Nginx module
sudo apt-get install -y libnginx-mod-http-passenger
````
