# This file is in the public-domain.
# This file is intentionally left stupid.

BZR  =
BZR += nxhtml
# There was a, likely accidental, purge of many libraries.
# Don't update until maintainer has responded to my request
# for clarification.
# BZR += vm

DARCS  =
DARCS += darcsum
DARCS += tex-smart-umlauts

SVN  =
SVN += cg
SVN += clang-format
SVN += confluence
SVN += dic-lookup-w3m
# This takes way too long to figure out that
# there actually are no relevant new commits.
# SVN += dsvn
SVN += helm-ls-svn

.PHONY: all $(BZR) $(DARCS) $(SVN)
.FORCE:

help:
	$(info make clone    - initial setup)
	$(info make update   - update all repositories)
	$(info make bzr      - update bzr repositories)
	$(info make darcs    - update darcs repositories)
	$(info make svn      - update svn repositories, except...)
	$(info make svn/dsvn - update dsvn repository (very slow))
	@echo

# clone ################################

clone:
	@echo "This takes a very very long time..."
	@echo
	@echo "Cloning bzr repositories..."
	git clone bzr::https://code.launchpad.net/~nxhtml/nxhtml/main bzr/nxhtml
	git clone bzr::https://code.launchpad.net/vm bzr/vm
	@echo "Cloning darcs repositories..."
	darcs/clone.sh darcsum https://hub.darcs.net/simon/darcsum
	darcs/clone.sh tex-smart-umlauts https://hub.darcs.net/lyro/tex-smart-umlauts
	@echo "Cloning svn repositories..."
	git svn clone https://beta.visl.sdu.dk/svn/visl/tools/vislcg3/trunk/emacs svn/cg
	git svn clone http://llvm.org/svn/llvm-project/cfe/trunk/tools/clang-format svn/clang-format
	git svn clone https://svn.code.sf.net/p/confluence-el/code/trunk/ svn/confluence
	git svn clone https://svn.osdn.jp/svnroot/dic-lookup-w3m/ svn/dic-lookup-w3m
	git svn clone https://svn.apache.org/repos/asf/subversion/trunk/contrib/client-side/emacs svn/dsvn
	git svn clone https://svn.macports.org/repository/macports/users/chunyang/helm-ls-svn.el svn/helm-ls-svn

# update ###############################

update: bzr darcs svn

## bzr #################################

bzr: $(addprefix bzr/,$(BZR))

bzr/%: .FORCE
	@echo "\nUpdating $@..."
	@cd $@ && git pull
	@cd $@ && git push -f git@github.com:emacsorphanage/$(@:bzr/%=%).git master

## darcs ###############################

darcs: $(addprefix darcs/,$(DARCS))

darcs/%: .FORCE
	@echo "\nUpdating $@..."
	@darcs/update.sh $(@:darcs/%=%)
	@cd $@/$(@:darcs/%=%)_git && git push -f git@github.com:emacsorphanage/$(@:darcs/%=%).git master

## svn #################################

svn: $(addprefix svn/,$(SVN))

svn/%: .FORCE
	@echo "\nUpdating $@..."
	@cd $@ && time git svn rebase
	@cd $@ && git push -f git@github.com:emacsorphanage/$(@:svn/%=%).git master
