JSONNET := jsonnet
JSONNET_FLAGS := --string --multi
OUTPUT_DIR := build
RULES_DIR := rules
LIB_DIR := lib

GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m

RULES_FILES := $(wildcard $(RULES_DIR)/*.jsonnet)
RULES_OUTPUTS := $(patsubst $(RULES_DIR)/%.jsonnet,$(OUTPUT_DIR)/rules/%.json,$(RULES_FILES))

.PHONY: all clean rules install check help lint format watch

all: rules
	@echo "$(GREEN)Build complete!$(NC)"

rules: $(RULES_OUTPUTS)
	@echo "$(GREEN)Rules built successfully$(NC)"

$(OUTPUT_DIR)/rules/%.json: $(RULES_DIR)/%.jsonnet $(LIB_DIR)/*.libsonnet
	@mkdir -p $(OUTPUT_DIR)/rules
	@echo "$(YELLOW)Building $<...$(NC)"
	@$(JSONNET) $< > $@ || (echo "$(RED)Error building $<$(NC)" && exit 1)

build-file:
ifndef FILE
	@echo "$(RED)Usage: make build-file FILE=path/to/file.jsonnet$(NC)"
	@exit 1
endif
	@mkdir -p $(OUTPUT_DIR)
	@echo "$(YELLOW)Building $(FILE)...$(NC)"
	@$(JSONNET) $(FILE) > $(OUTPUT_DIR)/$(notdir $(FILE:.jsonnet=.json))
	@echo "$(GREEN)Output: $(OUTPUT_DIR)/$(notdir $(FILE:.jsonnet=.json))$(NC)"

install: all
	@echo "$(YELLOW)Installing to Karabiner Elements...$(NC)"
	@mkdir -p ~/.config/karabiner/assets/complex_modifications
	@cp $(OUTPUT_DIR)/rules/*.json ~/.config/karabiner/assets/complex_modifications/ 2>/dev/null || true
	@echo "$(GREEN)Installed to ~/.config/karabiner/assets/complex_modifications/$(NC)"

install-file:
ifndef FILE
	@echo "$(RED)Usage: make install-file FILE=path/to/file.jsonnet$(NC)"
	@exit 1
endif
	@mkdir -p ~/.config/karabiner/assets/complex_modifications
	@$(JSONNET) $(FILE) > ~/.config/karabiner/assets/complex_modifications/$(notdir $(FILE:.jsonnet=.json))
	@echo "$(GREEN)Installed $(notdir $(FILE:.jsonnet=.json)) to Karabiner$(NC)"

check:
	@echo "$(YELLOW)Checking jsonnet syntax...$(NC)"
	@for f in $(RULES_FILES); do \
		$(JSONNET) --version >/dev/null 2>&1 || (echo "$(RED)jsonnet not installed$(NC)" && exit 1); \
		$(JSONNET) $$f > /dev/null && echo "$(GREEN)✓ $$f$(NC)" || echo "$(RED)✗ $$f$(NC)"; \
	done

lint:
	@echo "$(YELLOW)Linting jsonnet files...$(NC)"
	@command -v jsonnetfmt >/dev/null 2>&1 || (echo "$(RED)jsonnetfmt not installed$(NC)" && exit 1)
	@for f in $(RULES_FILES); do \
		jsonnetfmt --test $$f && echo "$(GREEN)✓ $$f$(NC)" || echo "$(YELLOW)⚠ $$f needs formatting$(NC)"; \
	done

format:
	@echo "$(YELLOW)Formatting jsonnet files...$(NC)"
	@command -v jsonnetfmt >/dev/null 2>&1 || (echo "$(RED)jsonnetfmt not installed$(NC)" && exit 1)
	@for f in $(RULES_FILES); do \
		jsonnetfmt -i $$f && echo "$(GREEN)✓ $$f$(NC)"; \
	done
	@echo "$(GREEN)Formatting complete$(NC)"

watch:
	@echo "$(YELLOW)Watching for changes... (Ctrl+C to stop)$(NC)"
	@command -v fswatch >/dev/null 2>&1 || (echo "$(RED)fswatch not installed. Install with: brew install fswatch$(NC)" && exit 1)
	@fswatch -o $(RULES_DIR) $(LIB_DIR) | xargs -n1 -I{} make all

clean:
	@echo "$(YELLOW)Cleaning build directory...$(NC)"
	@rm -rf $(OUTPUT_DIR)
	@echo "$(GREEN)Clean complete$(NC)"

help:
	@echo "Karabiner Elements Jsonnet Build System"
	@echo ""
	@echo "$(GREEN)Usage:$(NC)"
	@echo "  make                                              Build all jsonnet files"
	@echo "  make rules                                       Build rules files only"
	@echo "  make build-file FILE=path/to/file.jsonnet    Build a single file"
	@echo "  make install                                      Build and install to Karabiner"
	@echo "  make install-file FILE=path/to/file.jsonnet   Build and install a single file"
	@echo "  make check                                      Check jsonnet syntax"
	@echo "  make lint                                         Lint jsonnet files"
	@echo "  make format                                     Format jsonnet files"
	@echo "  make watch                                      Watch for changes and rebuild"
	@echo "  make clean                                       Remove build directory"
	@echo "  make help                                        Show this help"
	@echo ""
	@echo "$(GREEN)Requirements:$(NC)"
	@echo "  - jsonnet (brew install jsonnet)"
	@echo "  - jsonnetfmt (included with jsonnet)"
	@echo "  - fswatch (brew install fswatch) - for watch mode"
	@echo ""
	@echo "$(GREEN)Output:$(NC)"
	@echo "  Built files are placed in $(OUTPUT_DIR)/"
	@echo "  Install copies files to ~/.config/karabiner/assets/complex_modifications/"

debug:
	@echo "RULES_FILES: $(RULES_FILES)"
	@echo "RULES_OUTPUTS: $(RULES_OUTPUTS)"
