#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: server_package
#
# Copyright 2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

apt_packages = %w{ nagios3 nagios-nrpe-plugin nagios-images php5 php5-cgi libapache2-mod-php5 mysql-client percona-toolkit at }

apt_packages.each do |pkg|
  apt_package pkg do
    action :install
    options "--force-yes -o Dpkg::Options::='--force-confnew'"
  end
end
