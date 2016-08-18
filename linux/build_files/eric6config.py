# -*- coding: utf-8 -*-
#
# This module contains the configuration of the individual Pymakr installation
#

_pkg_config = {
    'ericDir': r'/usr/share/pymakr/modules',
    'ericPixDir': r'/usr/share/pymakr/pixmaps',
    'ericIconDir': r'/usr/share/pymakr/icons',
    'ericDTDDir': r'/usr/share/pymakr/DTDs',
    'ericCSSDir': r'/usr/share/pymakr/CSSs',
    'ericStylesDir': r'/usr/share/pymakr/Styles',
    'ericDocDir': r'/usr/share/doc/pymakr',
    'ericExamplesDir': r'/usr/share/doc/pymakr/Examples',
    'ericTranslationsDir': r'/usr/share/qt4/translations',
    'ericTemplatesDir': r'/usr/share/pymakr/DesignerTemplates',
    'ericCodeTemplatesDir': r'/usr/share/pymakr/CodeTemplates',
    'ericOthersDir': r'/usr/share/pymakr',
    'bindir': r'/usr/bin',
    'mdir': r'/usr/share/pymakr/modules',
    'apidir': r'/usr/share/pymakr/api',
    'apis': [],
    'macAppBundlePath': r'/Applications',
    'macAppBundleName': r'pymakr.app',
}

def getConfig(name):
    '''
    Module function to get a configuration value.

    @param name name of the configuration value (string)
    '''
    try:
        return _pkg_config[name]
    except KeyError:
        pass

    raise AttributeError('"{0}" is not a valid configuration value'.format(name))
