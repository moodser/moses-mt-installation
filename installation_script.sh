#! bin/bash

# It is recommended to run this script with GCC-5/G++-5 - For IRSTLM

MT_HOME=~/mt-root
MOSES=$MT_HOME/moses

sudo apt-get install build-essential git-core pkg-config automake libtool wget zlib1g-dev python-dev libbz2-dev cmake
sudo apt-get install libsoap-lite-perl
mkdir $MT_HOME
mkdir $MOSES
cd $MOSES

# BOOST
wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz
tar zxvf boost_1_64_0.tar.gz
mv boost_1_64_0 boost
rm boost_1_64_0.tar.gz
cd boost
./bootstrap.sh
./b2 -j4 --prefix=$PWD --libdir=$PWD/lib64 --layout=system link=static install || echo FAILURE
cd ..
export BOOST_ROOT=$MOSES/boost
export BOOST_LIBRARYDIR=$MOSES/boost/lib64

# MGIZA
git clone https://github.com/moses-smt/mgiza.git $MOSES/mgiza
cd mgiza/mgizapp
cmake .
make
make install
cd $MOSES

# IRSTLM
git clone https://github.com/irstlm-team/irstlm.git $MOSES/irstlm
cd irstlm
sh regenerate-makefiles.sh
./configure --prefix=$MOSES/irstlm
make
make install
cd ..

# CMPH
wget https://excellmedia.dl.sourceforge.net/project/cmph/v2.0.2/cmph-2.0.2.tar.gz
tar zxvf cmph-2.0.2.tar.gz
rm cmph-2.0.2.tar.gz
mv cmph-2.0.2 cmph
cd cmph
./configure
make
sudo make install
cd ..

# MOSES
git clone https://github.com/moses-smt/mosesdecoder.git
cd mosesdecoder
./bjam --with-boost=$MOSES/boost --with-cmph=$MOSES/cmph --with-irstlm=$MOSES/irstlm -j12
cd ~
clear
echo 'Program Execution Complete'



