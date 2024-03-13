# Makefile for Flutter project

# Variables
FLUTTER_CMD := flutter
DART_CMD := dart
MAIN_DART_FILE := lib/main.dart

# Targets
.PHONY: all clean run

all: run

clean:
	@$(FLUTTER_CMD) clean

run:
	@$(FLUTTER_CMD) run

# Target to build and run the Dart file
dart_run: $(MAIN_DART_FILE)
	@$(DART_CMD) $<

# Target to install dependencies
pub_get:
	@$(FLUTTER_CMD) pub get
