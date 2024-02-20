## Linux 1 Liners
* demigod mode
```
echo "$USER ALL=NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
```
* given a text list, find the first 1000 largest values in 3rd column
```
sort -k3 -r filelisting.ls | head -n 1000 
``` 	 
* flatten a folder structure, move all files into a folder called export
```
find . -mindepth 2 -type f -exec cp -t ./export -i '{}' \;
```
* flatten a folder structure, move all files into a zip archive.
```
find . -mindepth 2 -type f -exec zip -9 -jyr 'export.zip' '{}' \;
```
* list total directory size
```
ls -lAR | grep -v '^d' | awk '{total += $5} END {print "Total:", total}'
```
remove lines 2-7975 in a file (this writes the file, backup or skip the -i option and redirect to new file)
```
sed -i 2,7975 filename
```
* find files modifed in past 2 days:
```
find . -mtime -2 -type f
```
* delete any .htaccess files modified in the last 2 days:
```
find . -mtime -2 -type f -n .htaccess -delete
```

## One time things for new server
* timezone
```
sudo timedatectl set-timezone America/Los_Angeles
```

```
mkdir ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
```
Then create a key pair with puttyGen, save private key file, copy full public key, and paste it to ~/.ssh/authorized_keys file.
then in PuTTY under SSH->Auth, browse for the private key file.
```