.PHONY: help build clean mrproper deps upload

JMETER_VERSION = 3.3
JMETER         = apache-jmeter-$(JMETER_VERSION)
JMETER_TAR     = $(JMETER).tgz
JMETER_URL     = http://ftp.heanet.ie/mirrors/www.apache.org/dist/jmeter/binaries
GET_JMETER     = curl -O $(JMETER_URL)/$(JMETER_TAR)


# Options for fpm build target
JMETER_ARCH = x86_64
JMETER_RPM  = jmeter_$(JMETER_VERSION)_$(JMETER_ARCH).rpm
MAINTAINER  = "<jakub.jarosz@postpro.net>"
PREFIX      = /opt/jmeter
WORKDIR     = /tmp/installdir

# update this to the relevant rpm repository hosted in your local environment
REPO_HOST   = repo.erelis.it

define untar_jmeter
  tar -xzf $(JMETER_TAR) -C $(WORKDIR)/
endef

help:
	@echo
	@echo "=============== JMeter RPM builder ==============="
	@echo
	@echo "make deps     - run once to install fpm tool (RH)"
	@echo "make build    - build rpm"
	@echo "make clean    - clean the build environment"
	@echo "make mrproper - wipe out environment and artifacts"
	@echo


download:
	@echo "Downloading JMeter..."
	@echo
	test -f $(JMETER_TAR) || $(GET_JMETER) 


clean:
	@echo "Cleaning rpm build environment..."
	@echo
	rm -rf $(WORKDIR)
	mkdir $(WORKDIR)
	rm -rf *.rpm


mrproper: clean
	rm -rf $(JMETER_TAR)


build: clean download
	@echo "Building rpm package..."
	@echo
	$(call untar_jmeter)
	fpm -s dir -t rpm -n jmeter -v $(JMETER_VERSION) -p jmeter_VERSION_ARCH.rpm -a x86_64 -m $(MAINTAINER) --prefix $(PREFIX) -C $(WORKDIR)/$(JMETER) .


deps:
	@echo "Installing OS dependencies required by *fpm*..."
	@echo
	sudo yum install ruby-devel gcc make rpm-build rubygems ansible
	sudo gem install --no-ri --no-rdoc fpm


upload:
	@echo "Uploading rpm package and updating repository..."
	test -f $(JMETER_RPM) && ansible -i $(REPO_HOST), -b -m copy -a "src=$(JMETER_RPM) dest=/repos/jmeter/$(JMETER_RPM)" all
	test -f $(JMETER_RPM) && ansible -i $(REPO_HOST), -b -m shell -a "createrepo /repos/jmeter" all

