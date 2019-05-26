#!/bin/bash

pkg='octadist'

array=( 3.5 3.6 3.7 )

conda skeleton pypi $pkg

cd $pkg
wget https://gist.githubusercontent.com/rangsimanketkaew/1904bd45c933003ac076823861cd3ca8/raw/fa84b880097b942e1ec7010e43d5b3b741ef5eb0/bld.bat
wget https://gist.githubusercontent.com/rangsimanketkaew/1904bd45c933003ac076823861cd3ca8/raw/fa84b880097b942e1ec7010e43d5b3b741ef5eb0/build1.sh
cd ..

for i in "${array[@]}"
do
	conda-build --python $i $pkg
done

platforms=( osx-64 linux-32 linux-64 win-32 win-64 )

find ./conda-bld/linux-64/ -name *.tar.bz2 | while read file
do
    echo $file
    #conda convert --platform all $file  -o ./conda-bld/
    for platform in "${platforms[@]}"
    do
       conda convert --platform $platform $file  -o ./conda-bld/
    done    
done

find ./conda-bld/ -name *.tar.bz2 | while read file
do
    echo $file
    anaconda upload $file
done

