#
# Cookbook Name:: couchdb2
# Attributes:: couchdb
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the couchdb License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.couchdb.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
default['chef']['couchdb']['user'] = "couchdb"
default['chef']['couchdb']['log_file'] = "/var/log/couchdb/couchdb.log"
default['chef']['couchdb']['err_file'] = "/var/log/couchdb/couchdb.err"
default['chef']['couchdb']['respawn_timeout'] = 5
default['chef']['couchdb']['options'] = ""
