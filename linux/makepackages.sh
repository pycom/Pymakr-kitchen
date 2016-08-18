#!/usr/bin/env sh



release_version=$(grep "pymakr (.*)"  build_files/debian/changelog | head -1 | cut -d ' ' -f2 | grep -o "[^()]*")
short_version=$(echo $release_version | cut -d '-' -f1)

rm *.deb
(cd build_files;dpkg-buildpackage -b)

rm -R pymakr-$short_version

echo "generating the rpm"
alien -rkg *.deb

sed pymakr-$short_version/pymakr-$release_version.spec -e 's|\(Summary:.*\)[\.]$|\1|' | 
	sed 's|Group: .*$|Group: Applications/Editors|' | 
	sed 's|^.*_rpmdir.*$|%define _rpmdir .|' |
	sed 's|^.*Converted from a deb package.*$|An editor to work with Pycom products|' |
	sed "/Group:.*$/a Requires: qscintilla-python, pyserial" |
	sed "/Group:.*$/a BuildArch: noarch" | 
	sed "/Group:.*$/a URL: http://www.pycom.io/solutions/pymakr/" | 
	sed '/^Distribution:/d' |
	sed '/%dir "\/"/d' |
	sed '/%dir "\/usr\/bin\/"/d' > pymakr-$short_version/pymakr-$release_version.spec.out

mv pymakr-$short_version/pymakr-$release_version.spec.out pymakr-$short_version/pymakr-$release_version.spec

rpmbuild -v -bb pymakr-$short_version/pymakr-$release_version.spec --buildroot=$PWD/pymakr-$short_version
