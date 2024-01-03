.PHONY: test integration

test:
	@flutter test \
		--coverage \
		test/

integration:
	@flutter test \
		--coverage \
		integration_test/app_test.dart
