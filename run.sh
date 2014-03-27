echo "Rebuild wine-1.6.1?"
read REBUILD
case "$REBUILD" in
    y*|Y*)
    echo "Extracting..."
    rm -rf wine-1.6.1
    #tar xvjf wine-1.6.1.tar.bz2 # eXtract, Verbose, bzipped(j), File
    tar xjf wine-1.6.1.tar.bz2
    cd wine-1.6.1
    
    #sudo apt-get update
    #sudo apt-get upgrade
    #sudo apt-get install build-essential gcc-multilib g++-multilib gcc g++ flex bison libx11-dev:i386 libx11-dev:i386 libfreetype6-dev:i386

    ./configure --enable-win64
    make depend
    make -j 6 > make.log
    
    cd ../
esac

cd wine-1.6.1/libs/wine/
make clean
make -j 6 > make.log

cd ../../dlls/ntdll
make clean
make -j 6 > make.log

cd ../kernel32
cp ../../../patches/process.c ./
make clean
make -j 6 > make.log

cd ../../loader/
cp ../../patches/main.c ./
make clean
make -j 6 > make.log

rm *.so* proxywine*
cp ../../patches/proxywine.c ./
gcc -c -fPIC -I. -I../include  -D__WINESRC__ -o proxywine.o proxywine.c

gcc -shared -Wl,-soname,libproxywine.so.1 proxywine.o ../libs/port/libwine_port.a -lpthread -L../libs/wine -lwine -o libproxywine.so.1.0
rm -f libproxywine.so.1 && ln -s libproxywine.so.1.0 libproxywine.so.1
rm -f libproxywine.so && ln -s libproxywine.so.1 libproxywine.so

rm linuxmain*
cp ../../patches/linuxmain.c ./
gcc -c -I. -I../include -D__WINESRC__ -o linuxmain.o linuxmain.c

gcc -o linuxmain linuxmain.o -L. -lproxywine -Wl,--rpath,\$ORIGIN/../libs/wine -Wl,--rpath,\$ORIGIN/

rm dummy*
cp ../../patches/dummy.c ./
winegcc -w dummy.c -o dummy
# I don't know why needs this!!!
./wine64 ./dummy.exe.so

rm winmain*
cp ../../patches/windll.dll ./
cp ../../patches/winmain.c ./
winegcc -w winmain.c -o winmain

./linuxmain ./winmain.exe.so > log.log
