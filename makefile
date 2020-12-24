#把所有的目录做成变量，方便修改和移植 
BIN = ./bin
SRC = ./src
INC = ./include
OBJ = ./obj
 
#提前所有源文件(即：*.c文件)和所有中间文件(即：*.o)
SOURCE = $(wildcard ${SRC}/*.c)
OBJECT = $(patsubst %.c,${OBJ}/%.o,$(notdir ${SOURCE}))
 
#设置最后目标文件
TARGET = main
BIN_TARGET = ${BIN}/${TARGET}
 
CC = gcc 
CFLAGS = -g -Wall -I${INC} 
 
#用所有中间文件生成目的文件，规则中可以用 $^替换掉 ${OBJECT}
${BIN_TARGET}:${OBJECT}
	$(CC) -o $@ ${OBJECT}
 
#生成各个中间文件
${OBJ}/%.o:${SRC}/%.c 
	$(CC) $(CFLAGS) -o $@ -c $<
 
.PHONY:clean
clean:
	find $(OBJ) -name *.o -exec rm -rf {} \; #这个是find命令，不懂的可以查下资料
	rm -rf $(BIN_TARGET)

#	函数：
#	wildcard 这是扩展通配符函数，功能是展开成一列所有符合由其参数描述的文 件名，文件间以空格间隔；比如：罗列出src下的所有.c文件：$(wildcard ${SRC}/*.c)
#	patsubst 这是匹配替换函数， patsubst （ 需要匹配的文件样式，匹配替换成什么文件，需要匹配的源文件）函数。比如：用src下的*.c替换成对应的 *.o文件存放到obj中：$(patsubst  %.c, ${OBJ}/%.o, $(notdir $(SOURCE)))
#	notdir 这是去除路径函数，在上面patsubst函数中已经使用过，去除SOURCE中文件的所有目录，只留下文件名；
#	变量：
#	$@:表示目标文件；一般是在规则中这么用：gcc  -o $@  $(object)；
#       $^:表示所有依赖文件；一般是在规则中这么用：gcc -o $@  $^  ；用所有依赖文件链接成目的文件；
#       $<:表示第一个依赖文件；在规则中使用：gcc -o $@ -c $< ；其实这个时候就是每个依赖文件生成一个目的文件；
