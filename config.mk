COMP=accounts
NAME=ncm-$(COMP)
DESCR=accounts NCM component.
VERSION=5.0.5
RELEASE=1
AUTHOR=Luis Fernando Muñoz Mejías <Luis.Fernando.Munoz.Mejias@cern.ch>, Charles Loomis <charles.loomis@cern.ch>, Stephen Childs <childss@cs.tcd.ie>
MAINTAINER=Luis Fernando Muñoz Mejías <Luis.Fernando.Munoz.Mejias@cern.ch>

CCONFIGDIR=$(NCM_CONF)/$(COMP)
CONFIGFILE=$(CONFIGDIR)/config

NCM_EXTRA_REQUIRES=libuser

TESTVARS=

MANSECT=8
MANDIR=

DATE=17/09/10 16:28
