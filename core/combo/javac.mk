# Selects a Java compiler.
#
# Inputs:
#	CUSTOM_JAVA_COMPILER -- "eclipse", "openjdk". or nothing for the system 
#                           default
#
# Outputs:
#   COMMON_JAVAC -- Java compiler command with common arguments

# Allow to use custom memory limit
ifneq ($(CUSTOM_JAVA_MEMORY_LIMIT),)
    MEMORY_LIMIT := $(CUSTOM_JAVA_MEMORY_LIMIT)
else
    MEMORY_LIMIT := 256m
endif

# Allow to use custom target source
ifneq ($(CUSTOM_JAVA_TARGET_SOURCE),)
    TARGET_SOURCE := $(CUSTOM_JAVA_TARGET_SOURCE)
else
    TARGET_SOURCE := 1.5
endif

# Whatever compiler is on this system.
ifeq ($(BUILD_OS), windows)
    COMMON_JAVAC := development/host/windows/prebuilt/javawrap.exe -J-Xmx$(MEMORY_LIMIT) \
        -target $(TARGET_SOURCE) -source $(TARGET_SOURCE) -Xmaxerrs 9999999
else
    COMMON_JAVAC := javac -J-Xmx$(MEMORY_LIMIT) -target $(TARGET_SOURCE) -source $(TARGET_SOURCE) -Xmaxerrs 9999999
endif

# Eclipse.
ifeq ($(CUSTOM_JAVA_COMPILER), eclipse)
    COMMON_JAVAC := java -Xmx$(MEMORY_LIMIT) -jar prebuilt/common/ecj/ecj.jar -5 \
        -maxProblems 9999999 -nowarn
    $(info CUSTOM_JAVA_COMPILER=eclipse)
endif

# OpenJDK.
ifeq ($(CUSTOM_JAVA_COMPILER), openjdk)
    # We set the VM options (like -Xmx) in the javac script.
    COMMON_JAVAC := prebuilt/common/openjdk/bin/javac -target $(TARGET_SOURCE) \
        -source $(TARGET_SOURCE) -Xmaxerrs 9999999
    $(info CUSTOM_JAVA_COMPILER=openjdk)
endif
   
HOST_JAVAC ?= $(COMMON_JAVAC)
TARGET_JAVAC ?= $(COMMON_JAVAC)
    
#$(info HOST_JAVAC=$(HOST_JAVAC))
#$(info TARGET_JAVAC=$(TARGET_JAVAC))
