FROM registry.redhat.io/rhel9/php-81

# Install Composer
USER 0
RUN TEMPFILE=$(mktemp) && \
    curl -o "$TEMPFILE" "https://getcomposer.org/installer" && \
    php <"$TEMPFILE" && \
    mv composer.phar /usr/local/bin/composer
#    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
#    ./composer.phar install --no-interaction --no-ansi --optimize-autoloader

RUN chown -R 1001:0 /opt/app-root/src

USER 1001

# Add application sources
# ADD app-src .

# Install the dependencies

# RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to configure the PHP application
# and execs httpd -D FOREGROUND at the end
# See more in <version>/s2i/bin/run in this repository.
# Shortly what the run script does: The httpd daemon and php needs to be
# configured, so this script prepares the configuration based on the container
# parameters (e.g. available memory) and puts the configuration files into
# the approriate places.
# This can obviously be done differently, and in that case, the final CMD
# should be set to "CMD httpd -D FOREGROUND" instead.
CMD /usr/libexec/s2i/run
