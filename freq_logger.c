#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define SCALING_FREQ "/sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq"
#define CPUINFO_FREQ "/sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq"

int main(int argc, char ** argv){
	FILE *logfile;

	if(argc < 2){
		printf("Error, usage is: freq_logger [log file]\n");
		return 0;
	}

	logfile = fopen(argv[1], "w");

	fprintf(logfile, "time, scaling-cur-freq, cpuinfo-cur-freq\n");

	fclose(logfile);

	while(1){

	        logfile = fopen(argv[1], "a");

		FILE *file;
		int scaling, cpuinfo;

		file = fopen(SCALING_FREQ, "r");
		fscanf(file, "%i", &scaling);
		fclose(file);

                file = fopen(CPUINFO_FREQ, "r");
                fscanf(file, "%i", &cpuinfo);
                fclose(file);

		struct timespec spec;
    		clock_gettime(CLOCK_REALTIME, &spec);
		long time_ns = spec.tv_nsec;
		long time_s = spec.tv_sec;

		fprintf(logfile, "%ld.%03ld, %i, %i\n", time_s, time_ns/1000/1000, scaling, cpuinfo);
		fclose(logfile); //TODO: change to fflush(...)

		usleep(100*1000);
	}

	fclose(logfile);
	return 0;
}
