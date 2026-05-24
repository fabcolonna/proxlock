PROJECT := ProxLock.xcodeproj
SCHEME := ProxLock
CONFIGURATION := Debug
DERIVED_DATA := /private/tmp/ProxLockDerivedData
PACKAGE_CACHE := /private/tmp/ProxLockSourcePackages

.PHONY: bootstrap build check format format-check lint lsp-config

bootstrap:
	brew bundle

build:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration $(CONFIGURATION) -derivedDataPath $(DERIVED_DATA) -clonedSourcePackagesDirPath $(PACKAGE_CACHE) CODE_SIGNING_ALLOWED=NO build -quiet

format:
	swiftformat .

format-check:
	swiftformat --lint .

lint:
	swiftlint lint --strict --cache-path build/swiftlint

lsp-config:
	xcode-build-server config -project $(PROJECT) -scheme $(SCHEME)

check: format-check lint build
