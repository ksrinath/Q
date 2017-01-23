# ASSIGNMENT:2 CSV_LOAD
#Compile + run instructions:

#1) Change the directory and make the SUM directory as currently working directory on cmd line.
#e.g.: $ cd Desktop/CSV_LOAD/

#2) Compile the C code and create the adder.so file, the command is:
gcc -fPIC -shared -o cfunc.so cfunc.c

#3) In callc.c file Set the Path where to create the bin files:
#e.g.: binfilepath = "/home/pragati/Desktop/CSV_LOAD/"

#4) In load_csv.lua file set the path of cfunc.so file which u have created using step2:
#e.g.: local so_file_path_name = "/home/pragati/Desktop/CSV_LOAD/cfunc.so" 

#5) In main.lua file set the path of csv file which u will give as the input file:
#e.g.: local csv_file_path_name = "/home/pragati/Desktop/CSV_LOAD/csv_inputfile.csv"  

#6) Then run the parser.lua file, the command is:
luajit parser.lua

#7) Then run the callc.lua file, the command is:
luajit callc.lua

#8) Then run the load_csv.lua file, the command is:
luajit load_csv.lua

#9) Then run the main.lua file, the command is:
luajit main.lua



