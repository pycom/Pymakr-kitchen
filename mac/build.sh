#!/usr/bin/env bash

soft_version="1.0.0.b1"

main () {
	setup_app_dir
	run_install
	post_cleaning
	setup_bootstrap
	setup_main_info_plist
	setup_icon
	customize_python
	create_dmg
}


setup_app_dir () {
	rm -Rf output Pymakr.dmg Pymakr.app 2> /dev/null

	mkdir Pymakr.app
	mkdir -p Pymakr.app/Contents/MacOS
	mkdir -p Pymakr.app/Contents/Frameworks
	mkdir -p Pymakr.app/Contents/Resources/lib
	mkdir -p Pymakr.app/Contents/Resources/src

	cp -R /opt/local/Library/Frameworks/Python.framework Pymakr.app/Contents/Frameworks
	cp -R ../src/* Pymakr.app/Contents/Resources/src

	dnames=(Headers Python Resources)
	len=${#dnames[@]}
	for ((i=0; i < $len; i++)); do
		name=${dnames[i]}
		rm Pymakr.app/Contents/Frameworks/Python.framework/$name
		ln -s Versions/2.7/$name Pymakr.app/Contents/Frameworks/Python.framework/$name
	done

	rm Pymakr.app/Contents/Frameworks/Python.framework/Versions/Current
	ln -s 2.7 Pymakr.app/Contents/Frameworks/Python.framework/Versions/Current

	cp -R /opt/local/libexec/qt4/Library/Frameworks/* Pymakr.app/Contents/Frameworks


	cp -R /opt/local/libexec/qt4/lib/* Pymakr.app/Contents/Resources/lib
	convert_links Pymakr.app/Contents/Resources/lib "/opt/local/libexec/qt4/" "../"

	cp -R /opt/local/lib/lib{png,z,crypto,ssl}* Pymakr.app/Contents/Resources/lib

	rm -Rf Pymakr.app/Contents/Resources/src/.git 2> /dev/null
	rm -Rf Pymakr.app/Contents/Resources/src/i18n_disabled 2> /dev/null
}

convert_links () {
	links=$(find ${1} . -type l)
	for f in ${links}; do
		dest=$(readlink ${f})
		new_dest=$(echo ${dest} | sed "s|${2}|${3}|")
		rm ${f}
		ln -s ${new_dest} ${f}
	done
}

run_install () {
	DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
	DYLD_FRAMEWORK_PATH=Pymakr.app/Contents/Frameworks Pymakr.app/Contents/Frameworks/Python.framework/Versions/2.7/bin/python $DIR/Pymakr.app/Contents/Resources/src/install.py --noapis -d '.' 2> /dev/null
}

post_cleaning () {
	rm -Rf Pymakr.app/Contents/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/pymakr
	rm -Rf Pymakr.app/Contents/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/eric6*
	find Pymakr.app/Contents/Resources/src/ -name '*.pyc' | xargs rm

}


setup_bootstrap () {
	echo -e "${bootstrap}" > Pymakr.app/Contents/MacOS/Pymakr
	chmod +x Pymakr.app/Contents/MacOS/Pymakr	
}

setup_main_info_plist () {
	echo -e "${info_plist}" > Pymakr.app/Contents/Info.plist
}

setup_icon () {
	ln -s src/pixmaps/pymakr.icns Pymakr.app/Contents/Resources/pymakr.icns
}

customize_python () {
	plutil -replace CFBundleName -string Pymakr Pymakr.app/Contents/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/Info.plist
	plutil -replace CFBundleIconFile -string "pymakr.icns" Pymakr.app/Contents/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/Info.plist
	ln -s ../../../../../../../../Resources/src/pixmaps/pymakr.icns Pymakr.app/Contents/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/Resources/pymakr.icns
}

create_dmg () {
	build_path=$( set -- $PWD/files/{dmgbuild,biplist,mac_alias,ds_store}; IFS=:; echo "$*" )
	PYTHONPATH="${build_path}" python files/dmgbuild/scripts/dmgbuild -s files/dmgsettings.py "Pymakr" Pymakr.dmg
}

bootstrap=$(cat <<'BOOTSTRAP'
#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
DYLD_FRAMEWORK_PATH="${DIR}/Frameworks" DYLD_FALLBACK_LIBRARY_PATH="${DIR}/Resources/lib" "${DIR}/Frameworks/Python.framework/Versions/2.7/bin/pythonw" "${DIR}/Resources/src/pymakr.py" "$@"
BOOTSTRAP
)

info_plist=$(cat <<INFO_PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>
	<key>CFBundleDisplayName</key>
	<string>Pymakr</string>
	<key>CFBundleExecutable</key>
	<string>Pymakr</string>
	<key>CFBundleIconFile</key>
	<string>pymakr.icns</string>
	<key>CFBundleIdentifier</key>
	<string>com.pycom.pymkr</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>Pymakr</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$soft_version</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$soft_version</string>
	<key>LSHasLocalizedDisplayName</key>
	<false/>
	<key>LSMinimumSystemVersion</key>
	<string>10.6.0</string>
	<key>LSUIElement</key>
	<string>1</string>
	<key>NSAppleScriptEnabled</key>
	<false/>
	<key>NSHighResolutionCapable</key>
	<true/>
	<key>NSSupportsAutomaticGraphicsSwitching</key>
	<true/>
</dict>
</plist>
INFO_PLIST
)

main

