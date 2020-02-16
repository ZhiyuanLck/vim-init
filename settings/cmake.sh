cp="compile_commands.json"

if [ ! -d build ]
then
    mkdir build
fi

cd build
cmake -G 'Unix Makefiles' ..
cd ..

if [ -L $cp ]
then
    rm $cp
fi

ln -s build/$cp $cp
