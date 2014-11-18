maintainer        "Kyel Woodard"
maintainer_email  "CaptSpify@Yahoo.com"
description       "Installs cifs-utils"
version           "0.1.0"

recipe "cifs-utils", "Installs cifs-utils"

%w{ debian }.each do |os|
  supports os
end
