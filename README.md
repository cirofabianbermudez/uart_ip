# uart-ip

UART ip FPGA verilog/systemverilog

## Run lint and format

From the root directory run the following command to see the `help` message:

```plain
make -f scripts/Makefile.lint 
```

To lint the RTL and TB code run the following command:

```plain
make -f scripts/Makefile.lint lint
```

To format the code un `[Preview mode]` use the following command:

```plain
make -f scripts/Makefile.lint format-check
```

To format the code un `[Inplace mode]` use the following command:

```plain
make -f scripts/Makefile.lint format
```

In both `[Preview mode]` and `[Inplace mode]`, a `fmt_log/` directory is
created. In the first case, it contains the preview-formatted code, while in
the second, it holds a backup of the old code.

## Extras

- [lowRISC Verilog Coding Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)
- [verible GitHub](https://github.com/chipsalliance/verible)
