OUT         := java_compare
SRC         := main.cpp parser.y lexer.l
OBJ         := $(patsubst %.c, %.o, $(filter %.c, $(SRC)))
OBJ         += $(patsubst %.cpp, %.o, $(filter %.cpp, $(SRC)))

INTERMED	:= $(patsubst %.l, %.c, $(filter %.l, $(SRC)))
INTERMED	+= $(patsubst %.y, %.h, $(filter %.y, $(SRC)))
INTERMED	+= $(patsubst %.y, %.c, $(filter %.y, $(SRC)))

OBJ         += $(patsubst %.l, %.o, $(filter %.l, $(SRC)))
OBJ         += $(patsubst %.y, %.o, $(filter %.y, $(SRC)))

DEP         := $(OBJ:.o=.d)
DEP_DEPS	:= $(patsubst %.y, %.h, $(filter %.y, $(SRC)))

CFLAGS      := -Wall -Werror -pedantic -std=gnu99 -D_POSIX_SOURCE=1 -D_GNU_SOURCE
CXXFLAGS    := -Wall -Werror -pedantic -std=c++11 -D_POSIX_SOURCE=1 -D_GNU_SOURCE
LDFLAGS     :=
LDLIBS      := -lfl

BISON		?= bison

BISONFLAGS 	:= -d -k

DEBUG       ?= 0
VERBOSE     ?= 0

ifeq ($(DEBUG),1)
	CFLAGS += -O0 -g3 -ggdb -pg -DDEBUG=1
	CXXFLAGS += -O0 -g3 -ggdb -pg -DDEBUG=1
	LDFLAGS += -pg
	BISONFLAGS += --debug --verbose
endif

ifeq ($(VERBOSE),1)
	MSG := @true
	CMD :=
else
	MSG := @echo
	CMD := @
endif

.PHONY: release clean
.PRECIOUS: $(INTERMED)

release: CFLAGS += -O3
release: CXXFLAGS += -O3
release: $(OUT)

clean:
	$(MSG) -e "\tCLEAN\t"
	$(CMD)$(RM) $(INTERMED) $(OBJ) $(DEP) $(OUT) *.output

$(OUT): $(OBJ)
	$(MSG) -e "\tLINK\t$@"
	$(CMD)$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

%.c: %.l
	$(MSG) -e "\tLEX\t$@"
	$(CMD)$(LEX) -o $@ $(LEXFLAGS) $<

%.c %.h: %.y
	$(MSG) -e "\tBISON\t$@"
	$(CMD)$(BISON) -o $@ $(BISONFLAGS) $<

%.o: %.c %.d
	$(MSG) -e "\tCC\t$@"
	$(CMD)$(CC) $(CFLAGS) -c $< -o $@

%.d: %.c $(DEP_DEPS)
	$(MSG) -e "\tDEP\t$@"
	$(CMD)$(CC) $(CFLAGS) -MF $@ -MM $<

%.o: %.cpp %.d
	$(MSG) -e "\tCXX\t$@"
	$(CMD)$(CXX) $(CXXFLAGS) -c $< -o $@

%.d: %.cpp $(DEP_DEPS)
	$(MSG) -e "\tDEP\t$@"
	$(CMD)$(CXX) $(CXXFLAGS) -MF $@ -MM $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEP)
endif

