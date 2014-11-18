description       "Installs dnsutils"
version           "0.1.0"

recipe "dnsutils", "Installs dnsutils"

%w{ debian }.each do |os|
  supports os
end
