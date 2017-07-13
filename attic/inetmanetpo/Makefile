##
## OMNeT++/OMNEST Makefile for inetmanetpo
##
## This file was generated with the command:
##  opp_makemake --nolink -f --deep -O out -KINETMANET_PROJ=../inetmanet -DINET_IMPORT -I. -I$$\(INETMANET_PROJ\)/src -L$$\(INETMANET_PROJ\)/src -L$$\(INETMANET_PROJ\)/out/$$\(CONFIGNAME\)/src -lINET -d src -X.
##
#
## Output directory
#PROJECT_OUTPUT_DIR = out
#PROJECTRELATIVE_PATH =
#O = $(PROJECT_OUTPUT_DIR)/$(CONFIGNAME)/$(PROJECTRELATIVE_PATH)
#
## Other makefile variables (-K)
#INETMANET_PROJ=../inetmanet
#
##------------------------------------------------------------------------------
#
## Pull in OMNeT++ configuration (Makefile.inc)
#
#ifneq ("$(OMNETPP_CONFIGFILE)","")
#CONFIGFILE = $(OMNETPP_CONFIGFILE)
#else
#ifneq ("$(OMNETPP_ROOT)","")
#CONFIGFILE = $(OMNETPP_ROOT)/Makefile.inc
#else
#CONFIGFILE = $(shell opp_configfilepath)
#endif
#endif
#
#ifeq ("$(wildcard $(CONFIGFILE))","")
#$(error Config file '$(CONFIGFILE)' does not exist -- add the OMNeT++ bin directory to the path so that opp_configfilepath can be found, or set the OMNETPP_CONFIGFILE variable to point to Makefile.inc)
#endif
#
#include $(CONFIGFILE)
#
## we want to recompile everything if COPTS changes,
## so we store COPTS into $COPTS_FILE and have object
## files depend on it (except when "make depend" was called)
#COPTS_FILE = $O/.last-copts
#ifneq ("$(COPTS)","$(shell cat $(COPTS_FILE) 2>/dev/null || echo '')")
#$(shell $(MKPATH) "$O" && echo "$(COPTS)" >$(COPTS_FILE))
#endif
#
##------------------------------------------------------------------------------
## User-supplied makefile fragment(s)
## >>>
## <<<
##------------------------------------------------------------------------------
#
## Main target
#
#all:  submakedirs Makefile $(CONFIGFILE)
#	@# Do nothing
#
#submakedirs:  src_dir
#
#.PHONY: all clean cleanall depend msgheaders smheaders  src
#src: src_dir
#
#src_dir:
#	cd src && $(MAKE) all
#
#msgheaders:
#	$(Q)cd src && $(MAKE) msgheaders
#
#smheaders:
#	$(Q)cd src && $(MAKE) smheaders
#
#clean:
#	$(qecho) Cleaning...
#	$(Q)-rm -rf $O
#	$(Q)-rm -f $(TARGET)
#	$(Q)-rm -f $(call opp_rwildcard, . , *_m.cc *_m.h *_sm.cc *_sm.h)
#	-$(Q)cd src && $(MAKE) clean
#
#cleanall: clean
#	$(Q)-rm -rf $(PROJECT_OUTPUT_DIR)
#
## include all dependencies
#-include $(OBJS:%.o=%.d)

all: checkmakefiles
	cd src && $(MAKE)

clean: checkmakefiles
	cd src && $(MAKE) clean

cleanall: checkmakefiles
	cd src && $(MAKE) MODE=release clean
	cd src && $(MAKE) MODE=debug clean
	rm -f src/Makefile

makefiles:
	cd src && opp_makemake -f --deep

checkmakefiles:
	@if [ ! -f src/Makefile ]; then \
	echo; \
	echo '======================================================================='; \
	echo 'src/Makefile does not exist. Please use "make makefiles" to generate it!'; \
	echo '======================================================================='; \
	echo; \
	exit 1; \
	fi
