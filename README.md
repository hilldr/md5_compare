# Compare Two Directories with MD5sum
-----------------------------------------------------------------------------
Generate and check MD5 hashes recursively between two directories

David R. Hill

## HOW TO USE THIS SCRIPT
This script performs a series of actions:

1. Generate and verify MD5 hashes recursively in two unique user specified directories (results in 'md5sum\_check_DIR#.txt')
2. Compare list of MD5 hashes in DIR1 to list of MD5 hashes in DIR2
3. Output lists of files that are present in DIR1 but not present in DIR2 
4. Output list of files in DIR1 that are identical in DIR2 

## HOW TO INSTALL THIS SCRIPT 
``` sh
sudo cp md5cp /usr/local/bin
```
