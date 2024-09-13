ROOT_DIR := $(CURDIR)
RTL_DIR := $(ROOT_DIR)/hw/rtl
TB_DIR := $(ROOT_DIR)/hw/tb
FMT_LOG := $(ROOT_DIR)/fmt_log

RTL_FILES := $(shell find $(RTL_DIR) -name "*.sv" -or -name "*.v")
TB_FILES  := $(shell find $(TB_DIR) -name "*.sv" -or -name "*.v")

.PHONY: all check lint format help

all: lint

check:
	@echo "RTL files:"
	@for file in $(RTL_FILES); do \
		echo "$$file"; \
	done
	@echo "Testbench files:"
	@for file in $(TB_FILES); do \
		echo "$$file"; \
	done
	@mkdir -p $(ROOT_DIR)/fmt_log

lint:
	@echo "Running Verible linting tool"
	@verible-verilog-lint $(RTL_FILES) $(TB_FILES) || true

format:
	@echo "Running Verible formatting tool [Inplace mode]"
	@rm -rf $(FMT_LOG)/rtl_backup
	@mkdir -p $(FMT_LOG)/rtl_backup
	@for file in $(RTL_FILES); do \
		echo "Formatting $$file"; \
		backup_file="$${file##*/}"; \
		cp $$file $(FMT_LOG)/rtl_backup/$$backup_file; \
		verible-verilog-format --inplace $$file; \
	done

format-check:
	@echo "Running Verible formatting tool [Check mode]"
	@rm -rf $(FMT_LOG)/rtl
	@mkdir -p $(FMT_LOG)/rtl
	@for file in $(RTL_FILES); do \
		echo "Formatting $$file"; \
		fmt_file="$${file##*/}"; \
		fmt_file="$${fmt_file%.*}_fmt.$${file##*.}"; \
		verible-verilog-format $$file > $(FMT_LOG)/rtl/$$fmt_file; \
	done

help:
	@echo ""
	@echo "=================================================================="
	@echo "---------------------------- Targets -----------------------------"
	@echo "  all     : Run lint and format"
	@echo "  check   : Display list of RTL and testbench files"
	@echo "  lint    : Run Verible linter on RTL"
	@echo "  format  : Run Verible formatter on RTL"
	@echo "  help    : Display this help message"
	@echo "=================================================================="
	@echo ""	
