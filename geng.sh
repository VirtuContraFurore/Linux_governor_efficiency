# USAGE: geng.sh $output_directory
# se non gli passi la output_directory crea un sacco di files in mezzo ai coglioni dentro la $pwd

#N numero di task
#M numero di cpu (inutilizzato!! viene usato nel "genp")
#U utilizzazione
#T numero di taskset che genera

# $0 $1 $2 $3 - output_dir Number_of_tasks Tasksets_count Utilization

if [ "$#" -ne 4 ]; then
    echo "Usage:"
    echo "geng.sh [output_dir] [number of tasks per taskset] [number of taskset] [utilization]"
    echo "Output format: [run time] [period]"
    exit
fi


N=$2
T=$3
U=$4

#N=${N:-6}
#M=${M:-2}
#U=${U:-"1.8"}
#T=${T:-10}

#Quando stampo il formato "%(C) e %(T)" sono i run-time e i periodi che sto stampando

mydir=$(realpath $(dirname $0))

generate_ts() {
  S=$1
  SEED=$((0+10#$S))
  $mydir/taskgen.py -S $SEED -d logunif -s 1 -n $N -u $U -p 5000 -q 500000 -g 1000 --round-C -f "%(C)d %(T)d\n"
}

DIR=$1
mkdir -p $DIR
for I in $(seq -w 1 $T); do
  echo "Generating Taskset $I"
  generate_ts $I         > "$DIR"tsg$I.txt
done 

