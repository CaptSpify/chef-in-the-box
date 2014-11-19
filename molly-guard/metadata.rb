maintainer        "Kyel Woodard"
maintainer_email  "CaptSpify@Yahoo.com"
description       "Installs molly-guard"
version           "0.1.0"

recipe "molly-guard", "Installs molly-guard"

%w{ debian }.each do |os|
  supports os
end
