./circos -modules

-bash: circos: command not found
zoologi116:bin chriswheat$ ./circos -modules
ok       1.26 Carp
ok       0.31 Clone
missing            Config::General
ok    3.39_02 Cwd
ok   2.135_06 Data::Dumper
ok       2.51 Digest::MD5
ok       2.84 File::Basename
ok    3.39_02 File::Spec::Functions
ok       0.22 File::Temp
ok       1.51 FindBin
missing            Font::TTF::Font
missing            GD
missing            GD::Polyline
ok       2.38 Getopt::Long
ok       1.16 IO::File
ok       0.33 List::MoreUtils
ok       1.25 List::Util
missing            Math::Bezier
ok      1.997 Math::BigFloat
ok       0.06 Math::Round
missing            Math::VecStat
ok       1.02 Memoize
ok       1.30 POSIX
ok       1.06 Params::Validate
ok       1.51 Pod::Usage
missing            Readonly
ok 2011121001 Regexp::Common
missing            SVG
missing            Set::IntSpan
missing            Statistics::Basic
ok       2.34 Storable
ok       1.16 Sys::Hostname
ok       2.02 Text::Balanced
missing            Text::Format
ok     1.9725 Time::HiRes

# above are all the packages that need to be installed.
# following this tutorial on how to do this for Macs
http://zientzilaria.herokuapp.com/blog/2012/06/03/installing-circos-on-os-x/
# my scripts
sudo cpan
install Config::General		# done
install Font::TTF::Font		# done
 inst					# fail
install GD::Polyline		
install Math::Bezier		# done
install Math::VecStat		# done
install Readonly			# done
install SVG					# done
install Set::IntSpan		# done
install Statistics::Basic	# done
install Text::Format		# done

# GD is the most difficult, and needs a different approach

mkdir srctemp
cd srctemp
curl -O http://www.ijg.org/files/jpegsrc.v8d.tar.gz
tar -xzvf jpegsrc.v8d.tar.gz
cd jpeg-8d
./configure
make
sudo make install

cd ..
# curl -O ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.2.tar.gz
curl -O  ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.21.tar.gz
tar -xzvf libpng-1.6.21.tar.gz
cd libpng-1.6.21
./configure
make
sudo make install

# downloading GD
curl -O https://bitbucket.org/libgd/gd-libgd/downloads/libgd-2.1.0-rc2.tar.gz
tar -xzvf libgd-2.1.0-rc2.tar.gz
cd libgd-2.1.0-rc2
./configure

# missing Freetype and Fontconfig
# https://www.freetype.org/
# curl -O http://iweb.dl.sourceforge.net/project/freetype/freetype2/2.5.0/freetype-2.5.0.1.tar.bz2 
# tar xvfj freetype-2.5.0.1.tar.bz2
# cd freetype-2.5.0.1
# ./configure
# make
# sudo make install
# 
# tar xvfj freetype-2.6.2.tar.bz2
# cd freetype-2.6.2
# ./configure
# make
# sudo make install
# 
# export PATH="/Users/chriswheat/Research/software/circos/circos-0.69-2/bin/srctemp/freetype-2.6.2:$PATH"
# 
# 
# 
# curl -O https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.gz
# tar -xzvf fontconfig-2.11.1.tar.gz
# cd fontconfig-2.11.1
# ./configure
# make 
# sudo make install 
# 
# 
# checking for FREETYPE... no
# configure: error: in `/Users/chriswheat/Research/software/circos/circos-0.69-2/bin/srctemp/fontconfig-2.11.1':
# configure: error: The pkg-config script could not be found or is too old.  Make sure it
# is in your PATH or set the PKG_CONFIG environment variable to the full
# path to pkg-config.
# 
# Alternatively, you may set the environment variables FREETYPE_CFLAGS
# and FREETYPE_LIBS to avoid the need to call pkg-config.
# See the pkg-config man page for more details.
# 
# To get pkg-config, see <http://pkg-config.freedesktop.org/>.
# See `config.log' for more details

# trying different route
brew install freetype
brew install fontconfig


# alternative
http://kylase.github.io/CircosAPI/os-x-installation-guide/




Laptop installation
message from cpan
*** Remember to add these environment variables to your shell config
    and restart your shell before running cpan again ***

PATH="/Users/chriswheat/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/chriswheat/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/chriswheat/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/chriswheat/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/chriswheat/perl5"; export PERL_MM_OPT;

# in software
curl -O http://circos.ca/distribution/circos-0.69-2.tgz
tar xvf circos-0.69-2.tgz
sudo ln -s /Users/chriswheat/Documents/Research/software/circos-0.69-2/bin/circos /usr/local/bin/circos

# doesn't run to due wrong path, modify this
sudo su
cd /bin
ln -s /usr/bin/env env

# testing
bin/gddiag

circos -modules
ok       1.29 Carp
ok       0.36 Clone
missing            Config::General
ok       3.40 Cwd
ok      2.145 Data::Dumper
ok       2.52 Digest::MD5
ok       2.84 File::Basename
ok       3.40 File::Spec::Functions
ok       0.23 File::Temp
ok       1.51 FindBin
missing            Font::TTF::Font
ok       2.50 GD
ok        0.2 GD::Polyline
ok       2.39 Getopt::Long
ok       1.16 IO::File
ok       0.33 List::MoreUtils
ok       1.38 List::Util
missing            Math::Bezier
ok      1.998 Math::BigFloat
ok       0.06 Math::Round
missing            Math::VecStat
ok       1.03 Memoize
ok       1.32 POSIX
ok       1.08 Params::Validate
ok       1.61 Pod::Usage
missing            Readonly
ok 2013031301 Regexp::Common
missing            SVG
missing            Set::IntSpan
missing            Statistics::Basic
ok       2.41 Storable
ok       1.17 Sys::Hostname
ok       2.02 Text::Balanced
missing            Text::Format
ok     1.9725 Time::HiRes

# installing theses.
sudo cpan
install Config::General		# done
install Font::TTF::Font		# done
install Math::Bezier		# done
install Math::VecStat		# done
install Readonly			# done
install SVG					# done
install Set::IntSpan		# done
install Statistics::Basic	# done
install Text::Format		# done
# combined in batches
install Config::General Font::TTF::Font
install Math::Bezier Math::VecStat Readonly SVG
install Set::IntSpan Statistics::Basic Text::Format

circos -modules # all are now installed OK
# now testing, in circos folder
bin/gddiag
# allocated 20603 colors
# Created color diagnostic image at gddiag.png
# GD version 2.50
# generates a test image of color blocks

# next test
cd example
../bin/circos -conf etc/circos.conf
# ran great

# download tutorial
curl -O http://circos.ca/distribution/circos-tutorials-0.67.tgz
tar xvf circos-tutorials-0.67.tgz


# wheat example, hack of the quick tutorial

../bin/circos -conf circos.conf



/data/programs/exonerate-2.2.0/src/util/fastalength Pieris_napi_fullAsm.mfa 
11357067 Chromosome_1
15427984 Chromosome_2
15357576 Chromosome_3
14845049 Chromosome_4
14436900 Chromosome_5
13738639 Chromosome_6
14186557 Chromosome_7
14068971 Chromosome_8
13996725 Chromosome_9
13801688 Chromosome_10
13587546 Chromosome_11
12815933 Chromosome_12
12634055 Chromosome_13
12597868 Chromosome_14
12489475 Chromosome_15
11837383 Chromosome_16
11817185 Chromosome_17
11702215 Chromosome_18
10907953 Chromosome_19
10776756 Chromosome_20
10581609 Chromosome_21
9085402 Chromosome_22
6692213 Chromosome_23
5861113 Chromosome_24
4833285 Chromosome_25



...
hs1 100 200 hs2 250 300 color=blue
hs1 400 550 hs3 500 750 color=red,thickness=5p
hs1 600 800 hs4 150 350 color=black
...

pn1 7438649 7452382 bm1 6476352 6480321
pn1 7457750 7463028 bm1 6626647 6633541
pn1 7474102 7475114 bm1 6645490 6651476
pn1 7477843 7479400 bm1 6652315 6659622
pn1 7482552 7490087 bm1 6660811 6685841
pn1 7505797 7539658 bm1 6702416 6715229
pn1 7544282 7547235 bm1 6748908 6754550

ln -s /data/DB/annotation/reference_genomes/Bmori/Bmori_RAMEN2008assembly.chromosomelevel.fa .
/data/programs/exonerate-2.2.0/src/util/fastalength Bmori_RAMEN2008assembly.chromosomelevel.fa 

22395194 chr1
10467956 chr2
18213042 chr3
20915959 chr4
20918634 chr5
18949501 chr6
16282107 chr7
18895057 chr8
19011063 chr9
19757722 chr10
24125398 chr11
20507777 chr12
17991771 chr13
15625342 chr14
19511946 chr15
15238719 chr16
18380874 chr17
16692699 chr18
15216318 chr19
14637089 chr20
18458220 chr21
23365158 chr22
23133604 chr23
18494581 chr24
16676770 chr25
12282741 chr26
14467522 chr27
12350153 chr28

