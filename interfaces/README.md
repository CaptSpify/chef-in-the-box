Description 
===========
Installs/Configures the interfaces file using nslookup

Requirements
============
dns-utils (nslookup only)

Attributes
==========

Usage
=====
Apply it to a node, change the gateway & netmask in recipes/default.rb and it should pick up the IP Address from the local DNS Server.
