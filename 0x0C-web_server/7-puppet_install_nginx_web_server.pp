# Puppet manifest to install and configure Nginx

# Install Nginx package
package { 'nginx':
  ensure => 'installed',
}

# Configure Nginx service
service { 'nginx':
  ensure => 'running',
  enable => true,
}

# Create an Nginx server block configuration file
file { '/etc/nginx/sites-available/default':
  ensure => file,
  content => template('nginx_config.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Enable the server block configuration
file { '/etc/nginx/sites-enabled/default':
  ensure  => link,
  target  => '/etc/nginx/sites-available/default',
  require => File['/etc/nginx/sites-available/default'],
  notify  => Service['nginx'],
}

# Create a custom Nginx configuration template
file { '/etc/nginx/sites-available/default':
  ensure => present,
  content => template('nginx_config.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Define a custom Nginx configuration template
file { '/etc/nginx/nginx_config.erb':
  ensure => present,
  content => template('nginx_config.erb'),
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Define the custom Nginx configuration template content
file { '/etc/nginx/nginx_config.erb':
  ensure => present,
  content => "# Nginx server block configuration
server {
  listen 80;
  server_name _;

  location / {
    root   /var/www/html;
    index  index.html;
    add_header X-Powered-By 'Puppet';
    return 301 /redirect_me;
  }

  location /redirect_me {
    return 301 http://example.com;
  }

  location /favicon.ico {
    log_not_found off;
    access_log off;
  }

  location /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
  }

  error_page 404 /404.html;
  error_page 500 502 503 504 /50x.html;

  location = /50x.html {
    root /var/www/html;
  }
}
",
}

# Ensure the default Nginx welcome page is removed
file { '/var/www/html/index.nginx-debian.html':
  ensure => 'absent',
}

# Ensure a custom index.html file with "Hello World!" exists
file { '/var/www/html/index.html':
  ensure => file,
  content => 'Hello World!',
  require => Package['nginx'],
  notify  => Service['nginx'],
}
