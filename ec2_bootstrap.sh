#!/bin/bash
# Description:  This files bootstraps the EC2 host.  It updates, installs, and starts the required binaries to launch the wordpress container.

# Specify the source files for script variables. These are uploaded in the instances.tf file.
source /tmp/wp_vars
source /tmp/var_db_host
source /tmp/var_wp_url

# Update and install the required binaries.
sudo yum update -y
sudo amazon-linux-extras install docker -y

# Add the ec2-user to the docker group.
sudo usermod -a -G docker ec2-user

# Start the docker service.
sudo service docker start

# Launch the wordpress docker container with defined parameters below.
sudo docker run --name wordpress \
    -e "WORDPRESS_URL=$wp_url" \
    -e "WORDPRESS_TITLE=$wp_title" \
    -e "WORDPRESS_DB_HOST=$db_host" \
    -e "WORDPRESS_DB_NAME=$db_name" \
    -e "WORDPRESS_DB_USER=$db_user" \
    -e "WORDPRESS_DB_PASSWORD=$db_pass" \
    -e "WORDPRESS_DB_LOCALE=$wp_locale" \
    -e "WORDPRESS_ADMIN_USER=$wp_admin_user" \
    -e "WORDPRESS_ADMIN_PASS=$wp_admin_pass" \
    -e "WORDPRESS_ADMIN_EMAIL=$wp_admin_email" \
    -p 80:80 \
    --hostname wordpress \
    -dit wordpress

# Install the additional binaries in the new container and remove the base wordpress configuration file.
sudo docker exec -i wordpress /bin/bash -c 'apt update -y && apt install mariadb-client sendmail -y && rm -f /var/www/html/wp-config.php'

# Download the wordpress CLI binaries, make it executable and move it to the designated location.
sudo docker exec -i wordpress /bin/bash -c 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mkdir -p /usr/local/bin/wp && mv wp-cli.phar /usr/local/bin/wp/'

# Create a new wordpress configuration file and initialize the database schema with default content.
sudo docker exec -i wordpress /bin/bash -c '/usr/local/bin/wp/wp-cli.phar config create --dbhost=$WORDPRESS_DB_HOST --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --locale=$WORDPRESS_LOCALE --allow-root'

# Run installation to complete the wordpress initial configuration with the assigned variables.
sudo docker exec -i wordpress /bin/bash -c '/usr/local/bin/wp/wp-cli.phar core install --url="$WORDPRESS_URL" --title="$WORDPRESS_TITLE" --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASS --admin_email="$WORDPRESS_ADMIN_EMAIL" --allow-root'

# Run the MySQL updates to customize the default wordpress Installation.
sudo docker exec -i wordpress /bin/bash -c 'mysql -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD $WORDPRESS_DB_NAME < /tmp/update.sql'

# Completed.
echo -e "EC2 Bootstrap completed.\n"