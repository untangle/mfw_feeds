Name:       mfw_feeds
Version:    1.0
Release:    1%{?dist}
Summary:    mfw-feeds script
URL:        github.com/untangle/mfw_feeds
Source0:    %{name}.tar.gz
BuildArch:  noarch
License:    none
AutoReqProv: no

# This is a hack, since we copy in arch dependent binaries from the dev environment.
%define _binaries_in_noarch_packages_terminate_build   0

%description
mfw-feeds rpm to include scripts to be installed on EOS

%prep
%setup -n mfw_feeds

%build

%install
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/lib64
mkdir -p %{buildroot}/etc/rc.d/init.d
mkdir -p %{buildroot}/usr/share/geoip
mkdir -p %{buildroot}/etc/systemd/system
cp backup-scripts/files/* upgrade-scripts/files/*  %{buildroot}/usr/bin
cp wan-manager/files/wan-manager %{buildroot}/usr/bin
cp geoip-database/GeoLite2-Country.mmdb %{buildroot}/usr/share/geoip/
# jq required by pyconnector startup script.
cp /usr/bin/jq %{buildroot}/usr/bin
cp /lib64/libjq.so.1 %{buildroot}/usr/lib64
cp /lib64/libonig.so.5 %{buildroot}/usr/lib64
install -m 755 pyconnector/files/pyconnector %{buildroot}/usr/bin
install -m 755 pyconnector/files/connector.init %{buildroot}/etc/rc.d/init.d/pyconnector
install -m 755 pyconnector/files/pyconnector.service %{buildroot}/etc/systemd/system/pyconnector.service
install -m 755 speedtest-cli/speedtest.py %{buildroot}/usr/bin/speedtest-cli

%files
/etc/rc.d/init.d/pyconnector
/etc/systemd/system/pyconnector.service
/usr/bin/pyconnector
/usr/bin/speedtest-cli
/usr/bin/upgrade.sh
/usr/bin/upload-backup.sh
/usr/bin/wan-manager
/usr/bin/jq
/usr/lib64/libjq.so.1
/usr/lib64/libonig.so.5

%dir
/usr/share/geoip

%post
systemctl enable pyconnector.service