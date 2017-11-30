.PHONY: test

console:
	irb -Ilib -rsunat_invoice

test:
	cutest test/**/*_test.rb
	rubocop
