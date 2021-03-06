wannier90_path="../../../wannier90"
wannier90=$wannier90_path"/wannier90.x"
postw90=$wannier90_path"/postw90.x"


tar -xvf input/Fe_wan_files.tar.gz


NK_FFT=15
NK_div=2
NK_tot=$((NK_FFT*NK_div))

echo "wanierizing"


cp input/Fe.win0 Fe.win
$wannier90 Fe

rm Fe_band*  # Fe_wsvec.dat # 

exit
echo
echo "evaluating AHC using wannier19 from Fe_tb.dat"
#time ./calc_AHC.py tb $NK_FFT $NK_div 

echo
echo "evaluating AHC using postw90"


for EF in  # 12.6
do
echo "berry = true"> Fe.win 
echo "fermi_energy = $EF" >> Fe.win 
echo "berry_task = ahc">> Fe.win 
echo "berry_kmesh =  $NK_tot $NK_tot $NK_tot" >> Fe.win
cat input/Fe.win0 >> Fe.win

time $postw90 Fe
done


for dEF in 0.1 0.025 0.01
do

echo "berry = true"> Fe.win 
echo "fermi_energy_min = 12" >> Fe.win 
echo "fermi_energy_max = 13" >> Fe.win 
echo "fermi_energy_step = $dEF" >> Fe.win 
echo "berry_task = ahc">> Fe.win 
echo "berry_kmesh =  $NK_tot $NK_tot $NK_tot" >> Fe.win
cat input/Fe.win0 >> Fe.win

time $postw90 Fe

done

exit
#### to run the following partone needs to compile postw90 from the following repository:
#### https://github.com/stepan-tsirkin/wannier90/tree/saveHH

echo
echo "saving AA_R, HH_R"

echo  "get_oper_save=T"> Fe.win 
echo "get_oper_save_task=a" >> Fe.win 
cat input/Fe.win0 >> Fe.win
time $postw90 Fe

echo
echo "evaluating AHC using wannier19 from Fe_AA_R.dat, Fe_HH_R.dat, Fe_HH_save.info"
time ./calc_AHC.py aa $NK_FFT $NK_div 
