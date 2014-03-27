proxywine: linuxmain -> proxywine.so -> winmain.exe -> windll.dll

* download the source code of wine (wine-1.6.1.tar.bz2) and put it into the proxywine folder
* $sh run.sh (maybe some dependences of wine need installed, refer to install-wine-deps.sh)
* program start from proxywine\wine-1.6.1\loader
* use the command "cl /LD windll.c" in the VS2012 x64 native tools command prompt to generate windll.dll