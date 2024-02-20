# Tips for PHP hosting

Set PHP version for directory:
edit .htaccess and add
````

AddType application/x-httpd-php56 .php
Action application/x-httpd-php56 /cgi-bin/php56.cgi
#or
AddType application/x-httpd-php71 .php
Action application/x-httpd-php71 /fcgi-bin/php71_wrapper.sh
````

View errors in browser from a .php file that is crashing.  Add:
````
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
````

Creating an phpinfo.php file:
```
<?php echo shell_exec('whoami'); phpinfo(); ?>
```