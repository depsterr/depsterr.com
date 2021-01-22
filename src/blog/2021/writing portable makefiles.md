# Writing portable Makefiles

Makefiles are a great portable tool for compiling your programs which any POSIX compliant system will provide, however, a lot of Makefiles are GNU Makefiles, which are less portable. This blog post will not only explain how to write Makefiles, but how to replace GNU Makefile syntax.

## An introduction to Makefiles

In a Makefile, you can specify variables or macros as they are called in the world of Makefiles. All environment variables will also be available as macros.

	half_name=hello
	in_files=hello.o world.o

These can be referenced later by using `$(NAME)` or `${NAME}`.

	full_name=$(half_name)_world

You're also able to write by starting lines with a `#`.

	# This is a comment which will be ignored

Targets are used to specify how files are made. A target is defined by the following syntax:

	filename: depends
		action
		action2
		action3

This tells make that the file "filename" needs the file "depends" to be present to be made. To make "filename" it then runs the action lines in the system shell. Each line is run in a separate shell instance. Macros can be used in both target names, depends, and actions. Much like in shell macros which contain spaces will be split when evaluated, meaning a list of depends can be stored in a macro.

We can now use the macros we defined earlier to specify how to compile our hello world program:

	$(full_name): $(in_files)
		$(CC) $(CFLAGS) -o $@ $(in_files)

Here I used some special macros, the `$(CC)` macro is used to let users specify their preferred C compiler in the `CC` environment variable, if it is not set it will default to `cc` or `c99`. This is preferable to hard coding `gcc`, `clang`, or whatever compiler you might use since not everyone will use the same tools as you. The `$(CFLAGS)` macro is added to let the user specify flags to send to the C compiler in their `CFLAGS` environment variable. Lastly, and maybe most importantly, the `$@` macro evaluates to the name of the current target, which in this case is `$(full_name)`, which in turn evaluates to `hello_world`. Ultimately this target will run the following shell:

	cc -o hello_world hello.o world.o

But hold on, what about our hello.o and world.o files? Well, if they're already present make will happily use them, however, since we want to automate our build process we should specify how to build them too.

	hello.o: hello.c
		$(CC) -c $(CFLAGS) -o $@ hello.c
	world.o: world.c
		$(CC) -c $(CFLAGS) -o $@ world.c

Now running make will run the following:

	cc -c -o hello.o hello.c
	cc -c -o world.o world.c
	cc -o hello_world hello.o world.o

Now make knows how to make our full `hello_world` program, but why do we specify that `hello.o` depends on `hello.c`? We write the source ourselves, so surely there is no need to tell make this? Well, the beauty of make is that it checks the last edited date of depends to rebuild targets. In other words, if we edit hello.c and rerun make it will only run the following:

	cc -c -o hello.o hello.c
	cc -o hello_world hello.o world.o

This is because the `world.o` target is already up to date.

It's also worth mentioning that you can choose which target to make by running `make TARGET_NAME` and that by default the first defined target is the one ran.

We now have a complete Makefile for our hello world project!

	# Hello world Makefile
	half_name=hello
	in_files=hello.o world.o
	
	full_name=$(half_name)_world
	
	# main target
	$(full_name): $(in_files)
		$(CC) $(CFLAGS) -o $@ $(in_files)
	
	# depends
	hello.o: hello.c
		$(CC) -c $(CFLAGS) -o $@ hello.c
	
	world.o: world.c
		$(CC) -c $(CFLAGS) -o $@ world.c

Of course, this isn't a complete guide to writing Makefiles but it should give you enough of a grasp on it to understand the rest of this post.

## A powerful GNU Makefile

The following is a Makefile written by a now-graduated senior of mine, slightly modified by me to show more non-standard syntax. It is very powerful, and I used it as a template for writing my own Makefiles for a long time. However, it uses a lot of GNU extensions, making it a perfect example of how to replace them. I've added some comments throughout the file which explain the nonstandard syntax.


	# GNU make uses ?= to define a macro if not already set by an environment
	# variable. It also allows spaces between keys = and values.
	TARGET_EXEC ?= a.out
	
	BUILD_DIR ?= ./build
	SRC_DIRS ?= ./src
	
	# GNU make uses := to assign variable immediately instead of when needed.
	# GNU make adds the syntax $(shell command) to assign a macro the output
	# of a shell command.
	SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
	# GNU make allows for string substitution in variables. Here each word in
	# SRCS is represented by %, which is replaced by $(BUILD_DIR)/%.o
	# meaning we get a full list of object files from out list of source files.
	OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
	
	INC_DIRS := $(shell find $(SRC_DIRS) -type d)
	# GNU make adds the syntax $(addprefix prefix,words) which is used to
	# add a prefix to the beginning of each word in words.
	INC_FLAGS := $(addprefix -I,$(INC_DIRS))
	
	CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -pg -ggdb -std=c99 -pedantic -O2
	LDFLAGS = -lm -lSDL2 -lSDL2_gfx -lSDL2_image -lSDL2_ttf -pg
	CC = gcc
	CXX = g++
	
	# GNU make evaluates $^ to the full list of depends for the current target
	$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
		$(CC) $^ -o $@ $(LDFLAGS)
	
	# GNU make allows for generic targets matching patterns, here all files
	# in $(BUILD_DIR) with the extention .s.o are targeted.
	# assembly source
	$(BUILD_DIR)/%.s.o: %.s
		# GNU make adds the syntax $(dir file) used for getting the name
		# of the directory a file resides in.
		$(MKDIR_P) $(dir $@)
		# GNU make adds the $< macro to all targets. This macro evaluates
		# to the first dependency. In standard make this macro is only
		# defined for inference rules (more on that later).
		$(AS) $(ASFLAGS) -c $< -o $@
	
	# c source
	$(BUILD_DIR)/%.c.o: %.c
		$(MKDIR_P) $(dir $@)
		$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
	
	# c++ source
	$(BUILD_DIR)/%.cpp.o: %.cpp
		$(MKDIR_P) $(dir $@)
		$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@
	
	# The special target .PHONY is standard and tells make that one or more
	# targets do not correspond to a file. If this was not here make would
	# not run the clean target if a file named clean existed.
	.PHONY: clean profile stacktrace
	
	clean:
		$(RM) -r $(BUILD_DIR)
	
	# In GNU make adding macro definitions after a target name defines these
	# macros for that particular target.
	profile: CPPFLAGS += -pg
	profile: LDFLAGS += -pg
	profile: $(BUILD_DIR)/$(TARGET_EXEC)
	
	stacktrace: CPPFLAGS += -v -da -Q
	stacktrace: $(BUILD_DIR)/$(TARGET_EXEC)

This Makefile will compile or assemble all C, C++, and assembly source in the source directory and then link it, making it easy to reuse since there is no need to specify individual files.

### Special targets

Before we start translating this to standard make I'm going to explain two special targets. There are many special targets, and `.PHONY` is one of them. For a full list of special targets and their purpose refer to the POSIX make definition. The two we're interested in here are `.POSIX` and `.SUFFIXES`. `.POSIX` is a target that should be defined before anything else in a standard Makefile, it tells make to not use any extensions which might collide with the standard. The `.SUFFIXES` is used to specify file extensions (suffixes) which make should recognize.

### Generic targets and suffix rules

The generic rules that GNU make provides can be very useful. Thankfully, we can recreate them without any non-standard extensions. Let's look at a generic GNU make target:

	%.o: %.c
		$(CC) -c $(CFLAGS) -o $@ $<

In standard make we can use the `.SUFFIXES` target to ensure make knows of our file extensions.

	.SUFFIXES: .o .c
	.c.o
		$(CC) -c $(CFLAGS) -o $@ $<

Unfortunately it is not possible to specify another output directory like in the GNU make example, however, this is rarely necessary.

### Internal macros

In the GNU make example we had this target:

	$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
		$(CC) $^ -o $@ $(LDFLAGS)

This uses the non-standard `$^` macro, instead of this we could reuse `$(OBJS)`.

	$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
		$(CC) $(OBJS) -o $@ $(LDFLAGS)

If the depends are not already a macro you'd have to type them out manually. In general, I try to keep dependencies in macros to make this process easy.

### Shell and substitution macros

Standard make cannot replicate these features by itself, however, using a shell script and include line this behavior can be replicated.

For example, to emulate the following behavior:

	BUILD_DIR ?= ./build
	SRC_DIRS ?= ./src
	
	SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
	OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
	
	INC_DIRS := $(shell find $(SRC_DIRS) -type d)
	INC_FLAGS := $(addprefix -I,$(INC_DIRS))

We could put this in our Makefile:

	include config.mk

and create a script containing this:

	#!/bin/sh
	
	BUILD_DIR="${BUILD_DIR:-./build}"
	SRC_DIR="${BUILD_DIR:-./src}"
	
	SRCS="$(find "$SRC_DIR" -name '*.cpp' -or -name '*.c' -or -name '*.s')"
	OBJS="$(for SRC in $SRCS; do printf '%s\n' "$BUILD_DIR/$SRC.o"; done)"
	
	INC_DIRS="$(shell find "$SRC_DIR" -type d)"
	INC_FLAGS="$(for DIR in $INC_DIRS; do printf '%s\n' "-I$DIR"; done)"
	
	cat > config.mk <<-EOF
	BUILD_DIR=$BUILD_DIR
	SRC_DIR=$SRC_DIR
	SRCS=$SRCS
	OBJS=$OBJS
	INC_DIRS=$INC_DIRS
	INC_FLAGS=$INC_FLAGS
	EOF

Then, after creating new files one would rerun the script to recreate this configuration. This does require some more manual work, however, it also removes the need for make to run these shell commands on each invocation.

## Afterwords

I hope that after reading this, you, just like me have realized that writing standard Makefiles is easy and that they can be just as powerful as GNU Makefiles.

## See also

[POSIX make definition](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html)

[A tutorial on portable Makefiles by Chris Wellons](https://nullprogram.com/blog/2017/08/20/)

- - -

* Originally written: 2021-01-22 12:02

* Last edited: 
