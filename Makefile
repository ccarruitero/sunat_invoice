.PHONY: test

console:
	irb -Ilib -rsunat_invoice

test:
	cutest test/*.rb
