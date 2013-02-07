TOASTER=node_modules/coffee-toaster/bin/toaster

watch:
	$(TOASTER) . -w

build:
	$(TOASTER) . -c