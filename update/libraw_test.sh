exec_cmd() {
  cmd=("$@")
  echo "==> Executing: ${cmd[*]}"
  "${cmd[@]}"
  #echo "--> EXIT_CODE: $?"
  echo;
}

## requires c++ compiler:  zypper in gcc-c++
echo "1. Download and compile required tools"
cd /tmp; mkdir libraw; cd libraw
wget https://www.libraw.org/data/LibRaw-0.21.1.tar.gz
tar xvf LibRaw-0.21.1.tar.gz
cd LibRaw-0.21.1
./configure
make -j4 > make.log
export PATH=$PATH:$PWD/bin
cd ..

echo "2. Download the sample raw files"
wget -q http://www.rawsamples.ch/raws/panasonic/lx3/RAW_PANASONIC_LX3.RW2
wget -q http://www.rawsamples.ch/raws/olympus/RAW_OLYMPUS_E600.ORF
wget -q http://www.rawsamples.ch/raws/canon/g10/RAW_CANON_G10.CR2

echo "3. Decode the CR2 and ORF files"
exec_cmd dcraw_emu -v -q 1 -6 -fbdd 3 RAW_CANON_G10.CR2
exec_cmd dcraw_half RAW_OLYMPUS_E600.ORF

echo "4. Decode the ORF2 file"
exec_cmd mem_image -4 -1 -e RAW_OLYMPUS_E600.ORF

echo "5. Verify the files created"
exec_cmd file RAW*ppm RAW*jpg

echo "6. Split image channels"
exec_cmd 4channels -A -B -g RAW_PANASONIC_LX3.RW2

echo "7. Verify the splitted files"
exec_cmd file RAW*tiff

echo "8. Benchmarks"
exec_cmd postprocessing_benchmark RAW_PANASONIC_LX3.RW2

echo "9. Image metadata check"
exec_cmd raw-identify -v RAW_PANASONIC_LX3.RW2
