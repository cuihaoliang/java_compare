#ifndef __INTEGER_FLOATING_H__
#define __INTEGER_FLOATING_H__

enum integer_type_enum {
    INTEGER_TYPE_INTEGER    =   0,
    INTEGER_TYPE_LONG
};

struct integer_type {
    long long int value;
    enum integer_type_enum type;
};
typedef struct integer_type integer_type;

enum floating_type_enum {
    FLOATING_TYPE_FLOAT     =   0,
    FLOATING_TYPE_DOUBLE
};

struct floating_type {
    long double value;
    enum floating_type_enum type;
};
typedef struct floating_type floating_type;

#endif

