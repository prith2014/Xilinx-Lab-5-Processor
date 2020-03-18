
################################################################
# This is a generated script based on design: top_level_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_level_design_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# clock_div_UART, clock_div_VGA, controls, debounce, framebuffer, myALU, pixel_pusher, regs, uart, vga_ctrl

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name top_level_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set B [ create_bd_port -dir O -from 4 -to 0 B ]
  set CTS [ create_bd_port -dir O CTS ]
  set G [ create_bd_port -dir O -from 5 -to 0 G ]
  set R [ create_bd_port -dir O -from 4 -to 0 R ]
  set RTS [ create_bd_port -dir I RTS ]
  set btn [ create_bd_port -dir I btn ]
  set clk [ create_bd_port -dir I -type clk clk ]
  set hs [ create_bd_port -dir O hs ]
  set rx [ create_bd_port -dir I rx ]
  set tx [ create_bd_port -dir O tx ]
  set vs [ create_bd_port -dir O vs ]

  # Create instance: clock_div_UART_0, and set properties
  set block_name clock_div_UART
  set block_cell_name clock_div_UART_0
  if { [catch {set clock_div_UART_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $clock_div_UART_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clock_div_VGA_0, and set properties
  set block_name clock_div_VGA
  set block_cell_name clock_div_VGA_0
  if { [catch {set clock_div_VGA_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $clock_div_VGA_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: controls_0, and set properties
  set block_name controls
  set block_cell_name controls_0
  if { [catch {set controls_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $controls_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: dMem, and set properties
  set dMem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 dMem ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Coe_File {../../../../../../../../../Dropbox/Year 4/Fall/Embedded_Devices/Lab_5/hello_data2.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Load_Init_File {true} \
CONFIG.Read_Width_A {16} \
CONFIG.Read_Width_B {16} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Width_A {16} \
CONFIG.Write_Width_B {16} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $dMem

  # Create instance: debounce_0, and set properties
  set block_name debounce
  set block_cell_name debounce_0
  if { [catch {set debounce_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $debounce_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: framebuffer_0, and set properties
  set block_name framebuffer
  set block_cell_name framebuffer_0
  if { [catch {set framebuffer_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $framebuffer_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: irMem, and set properties
  set irMem [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 irMem ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Coe_File {../../../../../../../../../Dropbox/Year 4/Fall/Embedded_Devices/Lab_5/hello2.coe} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Load_Init_File {true} \
CONFIG.Memory_Type {Single_Port_ROM} \
CONFIG.Port_A_Write_Rate {0} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $irMem

  # Create instance: myALU_0, and set properties
  set block_name myALU
  set block_cell_name myALU_0
  if { [catch {set myALU_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $myALU_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: pixel_pusher_0, and set properties
  set block_name pixel_pusher
  set block_cell_name pixel_pusher_0
  if { [catch {set pixel_pusher_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pixel_pusher_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: regs_0, and set properties
  set block_name regs
  set block_cell_name regs_0
  if { [catch {set regs_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $regs_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: uart_0, and set properties
  set block_name uart
  set block_cell_name uart_0
  if { [catch {set uart_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $uart_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: vga_ctrl_0, and set properties
  set block_name vga_ctrl
  set block_cell_name vga_ctrl_0
  if { [catch {set vga_ctrl_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $vga_ctrl_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create port connections
  connect_bd_net -net btn_1 [get_bd_ports btn] [get_bd_pins debounce_0/btn]
  connect_bd_net -net clk_1 [get_bd_ports clk] [get_bd_pins clock_div_UART_0/clk] [get_bd_pins clock_div_VGA_0/clk] [get_bd_pins controls_0/clk] [get_bd_pins dMem/clka] [get_bd_pins debounce_0/clk] [get_bd_pins framebuffer_0/clk1] [get_bd_pins irMem/clka] [get_bd_pins myALU_0/clk] [get_bd_pins pixel_pusher_0/clock] [get_bd_pins regs_0/clk] [get_bd_pins uart_0/clk] [get_bd_pins vga_ctrl_0/clk]
  connect_bd_net -net clock_div_UART_0_clk_div [get_bd_pins clock_div_UART_0/clk_div] [get_bd_pins controls_0/en] [get_bd_pins framebuffer_0/en1] [get_bd_pins myALU_0/clk_en] [get_bd_pins regs_0/en] [get_bd_pins uart_0/en]
  connect_bd_net -net clock_div_VGA_0_clk_div [get_bd_pins clock_div_VGA_0/clk_div] [get_bd_pins framebuffer_0/en2] [get_bd_pins pixel_pusher_0/clock_en] [get_bd_pins vga_ctrl_0/clk_en]
  connect_bd_net -net controls_0_aluA [get_bd_pins controls_0/aluA] [get_bd_pins myALU_0/A]
  connect_bd_net -net controls_0_aluB [get_bd_pins controls_0/aluB] [get_bd_pins myALU_0/B]
  connect_bd_net -net controls_0_aluOp [get_bd_pins controls_0/aluOp] [get_bd_pins myALU_0/Opcode]
  connect_bd_net -net controls_0_charSend [get_bd_pins controls_0/charSend] [get_bd_pins uart_0/charSend]
  connect_bd_net -net controls_0_dAddr [get_bd_pins controls_0/dAddr] [get_bd_pins dMem/addra]
  connect_bd_net -net controls_0_dOut [get_bd_pins controls_0/dOut] [get_bd_pins dMem/dina]
  connect_bd_net -net controls_0_d_wr_en [get_bd_pins controls_0/d_wr_en] [get_bd_pins dMem/wea]
  connect_bd_net -net controls_0_fbAddr1 [get_bd_pins controls_0/fbAddr1] [get_bd_pins framebuffer_0/addr1]
  connect_bd_net -net controls_0_fbDout1 [get_bd_pins controls_0/fbDout1] [get_bd_pins framebuffer_0/din1]
  connect_bd_net -net controls_0_fb_wr_en [get_bd_pins controls_0/fb_wr_en] [get_bd_pins framebuffer_0/wr_en1]
  connect_bd_net -net controls_0_irAddr [get_bd_pins controls_0/irAddr] [get_bd_pins irMem/addra]
  connect_bd_net -net controls_0_rID1 [get_bd_pins controls_0/rID1] [get_bd_pins regs_0/id1]
  connect_bd_net -net controls_0_rID2 [get_bd_pins controls_0/rID2] [get_bd_pins regs_0/id2]
  connect_bd_net -net controls_0_regwD1 [get_bd_pins controls_0/regwD1] [get_bd_pins regs_0/din1]
  connect_bd_net -net controls_0_regwD2 [get_bd_pins controls_0/regwD2] [get_bd_pins regs_0/din2]
  connect_bd_net -net controls_0_send [get_bd_pins controls_0/send] [get_bd_pins uart_0/send]
  connect_bd_net -net controls_0_wr_enR1 [get_bd_pins controls_0/wr_enR1] [get_bd_pins regs_0/wr_en1]
  connect_bd_net -net controls_0_wr_enR2 [get_bd_pins controls_0/wr_enR2] [get_bd_pins regs_0/wr_en2]
  connect_bd_net -net dMem_douta [get_bd_pins controls_0/dIn] [get_bd_pins dMem/douta]
  connect_bd_net -net debounce_0_dbnc [get_bd_pins controls_0/rst] [get_bd_pins debounce_0/dbnc] [get_bd_pins regs_0/rst] [get_bd_pins uart_0/rst]
  connect_bd_net -net framebuffer_0_dout1 [get_bd_pins controls_0/fbDin1] [get_bd_pins framebuffer_0/dout1]
  connect_bd_net -net framebuffer_0_dout2 [get_bd_pins framebuffer_0/dout2] [get_bd_pins pixel_pusher_0/pixel]
  connect_bd_net -net irMem_douta [get_bd_pins controls_0/irWord] [get_bd_pins irMem/douta]
  connect_bd_net -net myALU_0_Y [get_bd_pins controls_0/aluResult] [get_bd_pins myALU_0/Y]
  connect_bd_net -net pixel_pusher_0_B [get_bd_ports B] [get_bd_pins pixel_pusher_0/B]
  connect_bd_net -net pixel_pusher_0_G [get_bd_ports G] [get_bd_pins pixel_pusher_0/G]
  connect_bd_net -net pixel_pusher_0_R [get_bd_ports R] [get_bd_pins pixel_pusher_0/R]
  connect_bd_net -net pixel_pusher_0_addr [get_bd_pins framebuffer_0/addr2] [get_bd_pins pixel_pusher_0/addr]
  connect_bd_net -net regs_0_dout1 [get_bd_pins controls_0/regrD1] [get_bd_pins regs_0/dout1]
  connect_bd_net -net regs_0_dout2 [get_bd_pins controls_0/regrD2] [get_bd_pins regs_0/dout2]
  connect_bd_net -net rx_1 [get_bd_ports rx] [get_bd_pins uart_0/rx]
  connect_bd_net -net uart_0_charRec [get_bd_pins controls_0/charRec] [get_bd_pins uart_0/charRec]
  connect_bd_net -net uart_0_newChar [get_bd_pins controls_0/newChar] [get_bd_pins uart_0/newChar]
  connect_bd_net -net uart_0_ready [get_bd_pins controls_0/ready] [get_bd_pins uart_0/ready]
  connect_bd_net -net uart_0_tx [get_bd_ports tx] [get_bd_pins uart_0/tx]
  connect_bd_net -net vga_ctrl_0_hcount [get_bd_pins pixel_pusher_0/hcount] [get_bd_pins vga_ctrl_0/hcount]
  connect_bd_net -net vga_ctrl_0_hs [get_bd_ports hs] [get_bd_pins vga_ctrl_0/hs]
  connect_bd_net -net vga_ctrl_0_vcount [get_bd_pins pixel_pusher_0/vcount] [get_bd_pins vga_ctrl_0/vcount]
  connect_bd_net -net vga_ctrl_0_vid [get_bd_pins pixel_pusher_0/vid] [get_bd_pins vga_ctrl_0/vid]
  connect_bd_net -net vga_ctrl_0_vs [get_bd_ports vs] [get_bd_pins pixel_pusher_0/VS] [get_bd_pins vga_ctrl_0/vs]

  # Create address segments

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port tx -pg 1 -y 510 -defaultsOSRD
preplace port CTS -pg 1 -y 20 -defaultsOSRD
preplace port rx -pg 1 -y 370 -defaultsOSRD
preplace port vs -pg 1 -y 250 -defaultsOSRD
preplace port btn -pg 1 -y 500 -defaultsOSRD
preplace port clk -pg 1 -y 520 -defaultsOSRD
preplace port RTS -pg 1 -y 20 -defaultsOSRD
preplace port hs -pg 1 -y 470 -defaultsOSRD
preplace portBus B -pg 1 -y 350 -defaultsOSRD
preplace portBus R -pg 1 -y 330 -defaultsOSRD
preplace portBus G -pg 1 -y 370 -defaultsOSRD
preplace inst dMem -pg 1 -lvl 4 -y 610 -defaultsOSRD
preplace inst controls_0 -pg 1 -lvl 3 -y 230 -defaultsOSRD
preplace inst pixel_pusher_0 -pg 1 -lvl 5 -y 360 -defaultsOSRD
preplace inst framebuffer_0 -pg 1 -lvl 4 -y 180 -defaultsOSRD
preplace inst uart_0 -pg 1 -lvl 2 -y 360 -defaultsOSRD
preplace inst debounce_0 -pg 1 -lvl 1 -y 510 -defaultsOSRD
preplace inst regs_0 -pg 1 -lvl 2 -y 670 -defaultsOSRD
preplace inst vga_ctrl_0 -pg 1 -lvl 4 -y 420 -defaultsOSRD
preplace inst clock_div_UART_0 -pg 1 -lvl 1 -y 420 -defaultsOSRD
preplace inst myALU_0 -pg 1 -lvl 2 -y 170 -defaultsOSRD
preplace inst irMem -pg 1 -lvl 4 -y 820 -defaultsOSRD
preplace inst clock_div_VGA_0 -pg 1 -lvl 3 -y 550 -defaultsOSRD
preplace netloc rx_1 1 0 2 NJ 370 NJ
preplace netloc btn_1 1 0 1 NJ
preplace netloc vga_ctrl_0_hcount 1 4 1 N
preplace netloc controls_0_dOut 1 3 1 1070
preplace netloc controls_0_dAddr 1 3 1 1120
preplace netloc controls_0_wr_enR1 1 1 3 280 800 NJ 800 1060
preplace netloc pixel_pusher_0_addr 1 3 3 1130 290 1400J 230 1660
preplace netloc controls_0_wr_enR2 1 1 3 290 530 570J 630 1050
preplace netloc controls_0_rID1 1 1 3 270 490 NJ 490 1030
preplace netloc controls_0_rID2 1 1 3 280 510 600J 600 1040
preplace netloc vga_ctrl_0_hs 1 4 2 1400J 470 NJ
preplace netloc vga_ctrl_0_vcount 1 4 1 N
preplace netloc uart_0_charRec 1 2 1 660
preplace netloc uart_0_ready 1 2 1 580
preplace netloc dMem_douta 1 2 2 690 650 1140J
preplace netloc controls_0_d_wr_en 1 3 1 1080
preplace netloc controls_0_irAddr 1 3 1 1090
preplace netloc irMem_douta 1 2 2 670 840 NJ
preplace netloc pixel_pusher_0_B 1 5 1 NJ
preplace netloc vga_ctrl_0_vs 1 4 2 1420 240 1670J
preplace netloc controls_0_fb_wr_en 1 3 1 1090
preplace netloc controls_0_regwD1 1 1 3 300 540 560J 620 1020
preplace netloc controls_0_regwD2 1 1 3 260 520 590J 610 1010
preplace netloc clk_1 1 0 5 20 820 220 820 620 820 1110 300 NJ
preplace netloc controls_0_aluOp 1 1 3 250 480 NJ 480 970
preplace netloc pixel_pusher_0_R 1 5 1 NJ
preplace netloc vga_ctrl_0_vid 1 4 1 N
preplace netloc controls_0_send 1 1 3 260 500 NJ 500 1000
preplace netloc uart_0_newChar 1 2 1 630
preplace netloc uart_0_tx 1 2 4 580J 710 NJ 710 NJ 710 1670J
preplace netloc controls_0_aluA 1 1 3 230 460 NJ 460 990
preplace netloc framebuffer_0_dout1 1 2 3 680 640 1130J 510 1390
preplace netloc regs_0_dout1 1 2 1 610
preplace netloc framebuffer_0_dout2 1 4 1 1410
preplace netloc pixel_pusher_0_G 1 5 1 NJ
preplace netloc clock_div_VGA_0_clk_div 1 3 2 1100 320 NJ
preplace netloc controls_0_charSend 1 1 3 270 260 650J 450 960
preplace netloc myALU_0_Y 1 2 1 660
preplace netloc controls_0_aluB 1 1 3 240 470 NJ 470 980
preplace netloc controls_0_fbDout1 1 3 1 N
preplace netloc regs_0_dout2 1 2 1 640
preplace netloc clock_div_UART_0_clk_div 1 1 3 200 10 660 10 1120
preplace netloc controls_0_fbAddr1 1 3 1 N
preplace netloc debounce_0_dbnc 1 1 2 210 80 650J
levelinfo -pg 1 0 110 430 830 1270 1540 1690 -top 0 -bot 910
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


