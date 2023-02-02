FROM registry.redhat.io/ubi9/php-81

# Add application sources
# ADD app-srr .
ADD phpinfo.php .

USER 0

# RUN dnf install -y php-sodium
# RUN yum install epel-release
RUN yum install libsodium libsodium-devel

# Install the dependencies
RUN TEMPFILE=$(mktemp) && \
    curl -o "$TEMPFILE" "https://getcomposer.org/installer" && \
    php <"$TEMPFILE" && \
    mv composer.phar /usr/local/bin/composer
    # ./composer.phar install --no-interaction --no-ansi --optimize-autoloader

USER 1001

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
