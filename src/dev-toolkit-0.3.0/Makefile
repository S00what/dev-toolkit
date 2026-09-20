PREFIX  ?= /usr/local
DESTDIR ?=
BINDIR   = $(PREFIX)/bin
DATADIR  = $(PREFIX)/share/dev-toolkit

.PHONY: install uninstall

install:
	install -Dm755 dev-toolkit $(DESTDIR)$(BINDIR)/dev-toolkit
	for d in backends lib maps toolkits; do \
		install -d $(DESTDIR)$(DATADIR)/$$d; \
		install -m644 $$d/* $(DESTDIR)$(DATADIR)/$$d/; \
	done

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/dev-toolkit
	rm -rf $(DESTDIR)$(DATADIR)
