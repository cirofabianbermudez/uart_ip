
SRCS = rtl/baud_gen.sv \
			 rtl/uart_rx.sv \
			 rtl/uart_tx.sv \
			 rtl/fifo.sv

all: format

format:
	verible-verilog-format --inplace $(SRCS)
