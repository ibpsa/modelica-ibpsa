############################################################
# Makefile for the regression tests that are run on travis
############################################################
ROOT = ../../../..

test-documentation:
	(cd $(ROOT)/IBPSA; ../bin/runUnitTests.py --validate-html-only)

test-dymola:
	(cd $(ROOT)/IBPSA && python ../bin/runUnitTests.py --single-package $(PACKAGE))
