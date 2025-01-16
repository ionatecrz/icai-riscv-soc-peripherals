# ICAI RISC-V SoC with Peripherals

## Project Description

This project focuses on extending the ICAI–RISC–V processor by integrating input and output peripherals to build a simple System on Chip (SoC). The design involves modifying the RISC-V architecture, implementing peripheral interfaces, and deploying the system on an FPGA.

## Repository Contents

- **`ALU32.vhd`**: 32-bit Arithmetic Logic Unit.
- **`BancoRegistros.vhd`**: Register bank module.
- **`CircuitoControl.vhd`**: Control circuit for instruction decoding.
- **`GeneradorInmediatos.vhd`**: Immediate value generator.
- **`Mux1.vhd`, `Mux2.vhd`, `Mux3.vhd`**: Multiplexer modules.
- **`PC.vhd`**: Program Counter.
- **`periferico.vhd`**: Input/Output peripheral integration.
- **`RAM.vhd`, `ROM.vhd`**: Memory modules.
- **`ruta_datos.vhd`**: Data path integration.
- **`images/`**: Block diagrams and RTL views.
- **`output_files/`**: FPGA programming files (`.sof`, `.pof`).

## Requirements

- **FPGA Development Board** (compatible with RISC-V design)
- **Quartus Prime** for synthesis and FPGA programming

## Usage Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/icai-riscv-soc-peripherals.git
   cd icai-riscv-soc-peripherals
   ```

2. **FPGA Programming**:
   - Open Quartus Prime.
   - Compile the project and program the FPGA using the `.sof` or `.pof` file from `output_files/`.

3. **Testing**:
   - Execute the assembly program to interact with the peripherals.
   - Verify proper input/output operation via the connected peripherals.

## Features

- **RISC-V Architecture Extension** with custom peripherals.
- **Memory Integration** using RAM and ROM modules.
- **Input/Output Peripheral Communication**.
- **Ready for FPGA Deployment**.

## Author

- **Íñigo de Oñate Cruz**  
- **Contact**: [LinkedIn](https://www.linkedin.com/in/%C3%AD%C3%B1igo-de-o%C3%B1ate-cruz-855b55263/)

## License

This project is licensed under the [MIT License](LICENSE), allowing use, modification, and distribution.

