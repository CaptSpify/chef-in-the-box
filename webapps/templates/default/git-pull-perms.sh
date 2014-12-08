#!/bin/bash
sleep 30
chown -R www-data:www-data /var/www
chmod -R 774 /var/www
chmod -R 770 /var/www/.git
