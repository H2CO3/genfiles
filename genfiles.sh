#!/bin/bash

if [ "$#" -lt 5 ]; then
	echo "";
	echo "genfiles.sh -- generate project file pairs";
	echo "Usage:";
	echo "	$0 <type> <project> <author> <license> file1 [file2, ...]";
	echo "";
	echo "Where <type> is one of: c c++ objc obj-c++";
	echo "";
	echo "Apart from the headers (with an extension of '.h'),";
	echo "the generated files will have the following extensions, based on <type>:";
	echo "	c: .c";
	echo "	c++: .cpp";
	echo "	objc: .m";
	echo "	obj-c++: .mm";
	echo "";
	exit 1;
fi

type=$1;
shift;
project=$1;
shift;
author=$1;
shift;
license=$1;
shift;

while [ "x$1" != "x" ]; do
	guard="__`echo $1 | tr [:lower:] [:upper:]`_H__";
	header=$1.h;
	impl="";
	
	case $type in
		"c")
			impl="$1.c";
			;;
		"c++")
			impl="$1.cpp";
			;;
		"objc")
			impl="$1.m";
			;;
		"obj-c++")
			impl="$1.mm";
			;;
		*)
			echo "Error: unrecognized type: $type";
			exit 1;
			;;
	esac
	
	touch $header $impl;
	
	echo "/**" >> $header;
	echo " * $header" >> $header;
	echo " * $project" >> $header;
	echo " * " >> $header;
	echo " * Created by $author on `date '+%a %d/%m/%Y'`." >> $header;
	echo " * Licensed under $license " >> $header;
	echo "**/" >> $header;
	echo "" >> $header;
	echo "#ifndef $guard" >> $header;
	echo "#define $guard" >> $header;
	echo "" >> $header;	
	echo "#ifdef __cplusplus" >> $header;
	echo "extern \"C\" {" >> $header;
	echo "#endif /* __cplusplus */" >> $header;
	echo "" >> $header;
	echo "#ifdef __cplusplus" >> $header;
	echo "}" >> $header;
	echo "#endif /* __cplusplus */" >> $header;
	echo "" >> $header;
	echo "#endif /* $guard */" >> $header;
	echo "" >> $header;
	
	echo "/**" >> $impl;
	echo " * $impl" >> $impl;
	echo " * $project" >> $impl
	echo " * " >> $impl;
	echo " * Created by $author on `date '+%a %d/%m/%Y'`" >> $impl;
	echo " * Licensed under $license " >> $impl;
	echo "**/" >> $impl;
	echo "" >> $impl;
	echo "#include \"$header\"" >> $impl;
	echo "" >> $impl;
	
	shift;
done

