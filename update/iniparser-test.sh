
cd $(dirname $0)
git clone https://github.com/ndevilla/iniparser.git
cd iniparser/example/
make

./iniexample 
for i in *.ini; do
  echo; echo "Executing ./parse $i";
  echo "==========================="; ./parse $i;
done

