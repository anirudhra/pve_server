## Homepage config backups

Contains basic app list for Heimdall (without logins), Heimdall custom apps not available in repo yet and backgrounds to be used to with any homepage app

### Instructions for adding custom apps in to Heimdall docker

unzip <custom_app.zip>
chown -R nobody:nogroup <custom_app_dir>
cp -R <custom_app_dir> ./config/www/SupportedApps
sudo docker exec -it heimdall bash
cd /app/www
php artisan register:app <app>

Ensure there is "artisan" inside the /app/www folder (else go to the correct folder)
