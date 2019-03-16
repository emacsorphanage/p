# This file is in the public-domain.
# This file is intentionally left stupid.

BZR  =
BZR += nxhtml
# There was a, likely accidental, purge of many libraries.
# Don't update until maintainer has responded to my request
# for clarification.
# BZR += vm

SVN  =
SVN += confluence
SVN += dic-lookup-w3m

.PHONY: all $(BZR) $(SVN)
.FORCE:

help:
	$(info make clone    - initial setup)
	$(info make update   - update all repositories)
	$(info make bzr      - update bzr repositories)
	$(info make svn      - update svn repositories)
	@echo

# clone ################################

clone:
	@echo "This takes a very very long time..."
	@echo
	@echo "Cloning bzr repositories..."
	git clone bzr::https://code.launchpad.net/~nxhtml/nxhtml/main bzr/nxhtml
	git clone bzr::https://code.launchpad.net/vm bzr/vm
	@echo "Cloning svn repositories..."
	git svn clone https://svn.code.sf.net/p/confluence-el/code/trunk/ svn/confluence
	git svn clone https://svn.osdn.jp/svnroot/dic-lookup-w3m/ svn/dic-lookup-w3m

# update ###############################

update: bzr svn

## bzr #################################

bzr: $(addprefix bzr/,$(BZR))

bzr/%: .FORCE
	@echo "\nUpdating $@..."
	@cd $@ && git pull
	@cd $@ && git push -f git@github.com:emacsorphanage/$(@:bzr/%=%).git master

## svn #################################

svn: $(addprefix svn/,$(SVN))

svn/%: .FORCE
	@echo "\nUpdating $@..."
	@cd $@ && time git svn rebase
	@cd $@ && git push -f git@github.com:emacsorphanage/$(@:svn/%=%).git master
