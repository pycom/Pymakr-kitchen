#!/bin/sh
VERSION=$(dpkg-parsechangelog | sed -rne 's,^Version: ([^-]+).*,\1,p')
echo $VERSION
cd debian
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-cs-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-de-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-es-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-fr-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-it-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-ru-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-tr-${VERSION}.tar.gz/download
wget http://sourceforge.net/projects/eric-ide/files/eric4/stable/${VERSION}/eric4-i18n-zh_CN.GB2312-${VERSION}.tar.gz/download
for name in eric4-i18n-*.tar.gz ; do tar xzf $name; done
mv -f eric4-${VERSION}/eric/i18n/eric4_*.ts i18n/
rm -rf eric4-${VERSION}
rm -f eric4-i18n-*.tar.gz*
cd ..
