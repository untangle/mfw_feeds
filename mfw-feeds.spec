Name:       mfw_feeds
Version:    1.0
Release:    1%{?dist}
Summary:    mfw-feeds script
URL:        github.com/untangle/mfw_feeds
Source0:    %{name}.tar.gz
BuildArch:  noarch
License:    none
AutoReqProv: no

%description
mfw-feeds rpm to include scripts to be installed on EOS

%prep
%setup -n mfw_feeds

%build

%install
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/geoip
cp backup-scripts/files/* upgrade-scripts/files/*  %{buildroot}/usr/bin
cp wan-manager/files/wan-manager %{buildroot}/usr/bin
cp geoip-database/GeoLite2-Country.mmdb %{buildroot}/usr/share/geoip/
install -m 755 speedtest-cli/speedtest.py %{buildroot}/usr/bin/speedtest-cli

%files
/usr/bin/wan-manager
/usr/bin/stats_schema
/usr/bin/upload-backup.sh
/usr/bin/upgrade.sh
/usr/share/geoip/GeoLite2-Country.mmdb
/usr/bin/speedtest-cli
