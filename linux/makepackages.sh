#!/usr/bin/env sh

rm *.deb
(cd files;dpkg-buildpackage -b)

rm -R pymakr-1.0.0.b1
alien -rkg *.deb

sed pymakr-1.0.0.b1/pymakr-1.0.0.b1-1.spec -e 's|\(Summary:.*\)[\.]$|\1|' | 
	sed 's|Group: .*$|Group: Applications/Editors|' | 
	sed 's|^.*_rpmdir.*$|%define _rpmdir .|' |
	sed 's|^.*Converted from a deb package.*$|An editor to work with Pycom products|' |
	sed "/Group:.*$/a Requires: qscintilla-python, pyserial" |
	sed "/Group:.*$/a BuildArch: noarch" | 
	sed "/Group:.*$/a URL: http://www.pycom.io/solutions/pymakr/" | 
	sed '/^Distribution:/d' |
	sed '/%dir "\/"/d' |
	sed '/%dir "\/usr\/bin\/"/d' > pymakr-1.0.0.b1/pymakr-1.0.0.b1-1.spec.out

mv pymakr-1.0.0.b1/pymakr-1.0.0.b1-1.spec.out pymakr-1.0.0.b1/pymakr-1.0.0.b1-1.spec

rpmbuild -v -bb pymakr-1.0.0.b1/pymakr-1.0.0.b1-1.spec --buildroot=$PWD/pymakr-1.0.0.b1
