# Backup for export

* DB backup:  `mysqldump -h 127.0.0.1 -u root -p wordpress > ~/wordpress$(date +"%Y-%m-%d").bak`
* Site backup: `tar -czvf ~/wordpress$(date +"%Y-%m-%d").tar.gz /usr/share/wordpress`
* Content backup: `sudo tar -czvf ~/wp-content$(date +"%Y-%m-%d").tar.gz /var/lib/wordpress/wp-content`
* Apache and WP Config: `tar -czvf ~/wpconfig.tar.gz /etc/wordpress/config.php /etc/apache2/sites-available/wp.conf`

# Security Notes

* Delete old themes from wp-content/themes/
* Delete deactivated plugins from the admin page, they can still be executed
* Block .php from running from the wp-content/uploads/ or wp-includes/ dirs by creating .htaccess:

````
<Files *.php>
  deny from all
</Files>
````

* Wordpress puts empty index.php files with a comment `// Silence is Golden` which are there to prevent indexes from being listed by a web server.  You could also just disable indexes from being listed by adding a line to the root level .htaccess:  `Options -Indexes`

