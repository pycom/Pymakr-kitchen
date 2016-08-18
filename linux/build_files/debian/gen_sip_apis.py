#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Copyright (c) 2002-2004 Detlev Offenbach <detlev@die-offenbachs.de>
# Adapted for usage with Debian by Torsten Marek <shlomme@gmx.net>
import os
import sys
import PyQt4.pyqtconfig as pyqtconfig

apidir = sys.argv[1]
if not os.path.isdir(apidir):
    print "Generating the api directory."
    os.makedirs(apidir)

sip = "/usr/bin/sip"

def createAPIFiles(baseDir, modules, defaultImports, getFlags):
    for mod in modules:
        try:
            sipfile = os.path.join(baseDir, mod, "%smod.sip" % (mod, ))
            apifile = os.path.join(apidir, os.path.split(sipfile.replace("mod.sip", ".api"))[1])
            args = [sip, "-a", apifile,
                    "-I", os.path.join(baseDir, mod),
                    "-I", baseDir] \
                    + defaultImports \
                    + getFlags(mod) \
                    +  [sipfile]
            print "Generating %s ..." % apifile
            ret = os.spawnv(os.P_WAIT, sip, args)
            if ret != 0:
                print "Error: the process returned the exit code %d" % ret
        except OSError:
            print "Warning: The module '%s' does not exist." % mod



qtsipdir = os.path.abspath(pyqtconfig._pkg_config['pyqt_sip_dir'])
modules = pyqtconfig._pkg_config['pyqt_modules'].split()

#createAPIFiles(qtsipdir, modules, [],
#               lambda x: pyqtconfig._pkg_config["pyqt_%s_sip_flags" % (x,)].split())
createAPIFiles(qtsipdir, modules, [],
               lambda x: pyqtconfig._pkg_config["pyqt_sip_flags"].split())
               

try:
    import PyKDE4.pykdeconfig as pykdeconfig
    kdesipdir = "/usr/share/sip/PyKDE4"
    modules = pykdeconfig._pkg_config['pykde_modules'].split()

    extraimport = []
    # just import anything for anything else, so we get rid of keeping track of the
    # inter-module deps
    for mod in modules:
        extraimport.extend(["-I", os.path.join(kdesipdir, mod)])
    extraimport.extend(["-I", qtsipdir])

    createAPIFiles(kdesipdir, modules, extraimport,
                   lambda x: pykdeconfig._pkg_config["pykde_kde_sip_flags"].split())
except:
    print "Error: No PyKDE4 api files generated"
