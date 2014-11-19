name              "keepalived"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures keepalived"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.1.0"
supports          "ubuntu"

recipe "keepalived", "Installs and configures keepalived"
recipe "check_scripts", "File containing check scripts"
recipe "instances", "File containing instances"
