maintainer        "Kyel Woodard"
maintainer_email  "CaptSpify@Yahoo.com"
description       "Installs ampache"
version           "0.1.0"

recipe "ampache", "Installs ampache"

%w{ debian }.each do |os|
  supports os
end
