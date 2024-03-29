# Puppet manifest to configure SSH client
# Disable password authentication
file_line { 'Turn off passwd auth':
  path    => '/etc/ssh/sshd_config',
  line    => 'PasswordAuthentication no',
  match   => '^#?PasswordAuthentication',
}

# Specify the identity file (private key)
file_line { 'Declare identity file':
  path    => '~/.ssh',
  line    => 'IdentityFile ~/.ssh/id_rsa',
  match   => '^#?IdentityFile',
}
