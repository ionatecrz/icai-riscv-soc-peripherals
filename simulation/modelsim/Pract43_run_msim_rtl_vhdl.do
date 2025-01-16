transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/ALU32.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/ROM.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/BancoRegistros.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/GeneradorInmediatos.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/PC.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/PC_IR.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/IR.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/AluR.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/Mux1.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/Mux2.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/Mux3.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/CircuitoControl.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/RAM.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/Mux3anadido.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/UCPuenteAPB2.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/decod.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/periferico.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/ruta_datos.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/PuenteAPB2.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/RISCV.vhd}
vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/Pract5.vhd}

vcom -93 -work work {C:/Users/ionat/Documents/ICAI/2023-2024/2do Cuatri/Sistemas Digitales II/Lab/Practicas/Pract5/tb_RAM.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  tb_RAM

add wave *
view structure
view signals
run -all
