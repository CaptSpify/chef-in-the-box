maintainer        "Kyel Woodard"
maintainer_email  "CaptSpify@Yahoo.com"
description       "Installs subsonic"
version           "0.1.0"

recipe "subsonic", "Installs subsonic"

%w{ debian }.each do |os|
  supports os
end
