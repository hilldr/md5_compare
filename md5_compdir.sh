#! /bin/bash
## generate and check MD5 hash recursively between two directories
## David R. Hill
## -----------------------------------------------------------------------------
## HOW TO USE THIS SCRIPT
## This script performs a series of actions:
## 1 - Generate and verify MD5 hashes recursively in two unique user specified
##     directories (results in 'md5sum_check_DIR#.txt')
## 2 - Compare list of MD5 hashes in DIR1 to list of MD5 hashes in DIR2
## 3 - Output lists of files that are present in DIR1 but not present in DIR2
##     called 'different_files.log'
## 4 - Output list of files in DIR1 that are identical in DIR2 called
##     'identical_files.log'

## Setup variables
## set number of cores for multicore MD5 generation
MAXCORES=$(grep -c ^processor /proc/cpuinfo)

read -e -p "Source directory (where are you copying from?):" DIR1
read -e -p "Target directory (where are you copying to?):" DIR2
read -p "How many cores (max is "$MAXCORES")?:" CORES

while true; do
    read -p "Compare MD5 checksums in "$DIR1" to "$DIR2" using "$CORES" core(s) [y/n]?" yn
    case $yn in
        [Yy]* ) 
	    ## generate md5sum recursively
	    find $DIR1 -type f | parallel -j $CORES md5sum > md5sum_DIR1.txt 
	    ## verify md5sums against files
	    md5sum -c md5sum_DIR1.txt > md5sum_check_DIR1.txt
	    cut -f 1 -d\  md5sum_DIR1.txt > list1.log

	    ## generate md5sum recursively
	    find $DIR2 -type f | parallel -j $CORES md5sum > md5sum_DIR2.txt 
	    ## verify md5sums against files
	    md5sum -c md5sum_DIR2.txt > md5sum_check_DIR2.txt
	    cut -f 1 -d\  md5sum_DIR2.txt > list2.log

	    ## compare two md5sum reports and output list of differences
	    ## and list of similarities
	    ## this is a list of files that are different between the two directories
	    ## create data file and add header line
	    echo '## These files are NOT present in '$DIR2 > different_files.log 
	    echo 'Checksum path' >> different_files.log 
	    cat md5sum_DIR1.txt | parallel -j $CORES --pipe --block 2000M grep -v -f list2.log {} >> different_files.log 

	    ## this is a list of files that are the same in both directories
	    echo '## These files are identical in both '$DIR1' and '$DIR2 > identical_files.log
	    echo 'Checksum path' >> identical_files.log 
	    cat md5sum_DIR1.txt | parallel -j $CORES --pipe --block 2000M grep -f list2.log {} >> identical_files.log 
	    ## remove extraneous log files
	    rm list1.log list2.log
	    
	    break;;
	
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
done

