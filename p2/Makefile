VAGRANT := ./scripts/vagrant.sh

.PHONY: up down reload status ssh destroy clean clean-all

up:
	$(VAGRANT) up

down:
	$(VAGRANT) halt

reload:
	$(VAGRANT) reload --provision

status:
	$(VAGRANT) status

ssh:
	$(VAGRANT) ssh

destroy:
	$(VAGRANT) destroy -f

clean: destroy
	rm -rf .vagrant

# Removes cached boxes as well; next 'up' will re-download.
clean-all: clean
	rm -rf .vagrant.d
