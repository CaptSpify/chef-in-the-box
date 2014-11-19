maintainer        "Kyel Woodard"
maintainer_email  "CaptSpify@Yahoo.com"
description       "Installs mlocate"
version           "0.1.0"

recipe "mlocate", "Installs mlocate"

%w{ debian }.each do |os|
  supports os
end
