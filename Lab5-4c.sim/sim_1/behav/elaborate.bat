@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto ad39b2c8fc2846b0834f92a87c78b754 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L blk_mem_gen_v8_3_5 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot top_level_design_wrapper_behav xil_defaultlib.top_level_design_wrapper xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
