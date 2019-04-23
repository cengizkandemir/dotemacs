#include <iostream>

#define SOME_MACRO_DEF(arg1, arg2) \
    if(arg1 > arg2) {              \
        ;                          \
    }                              \
    else {                         \
        ;                          \
    }

namespace
{

int values[] =
{
    1,
    2,
    3
};

template <typename SomeReallyReallyLongTypeParam,
        typename SomeMoreReallyReallyLongTypeParam, typename T, typename L,
        typename S>
void some_templated_func(SomeReallyReallyLongTypeParam arg1,
        SomeMoreReallyReallyLongTypeParam arg2, T arg3, L arg4, S arg5)
{
    ;
}

} // anonymous

namespace foo_bar
{

class foo
{
    enum class enum_t : int
    {
        a,
        b,
        c
    };

    using int_t = int;
    using this_needs_to_be_a_long_type_name = int;

private:
    foo(int_t first, int_t second)
        : first_(first)
        , second_(second)
    {
        std::cout << "foo" << std::endl;
    }

    void bar(enum_t val) const;

    int fancy_func(this_needs_to_be_a_long_type_name arg1,
            int arg2, int arg3, this_needs_to_be_a_long_type_name arg4);

    int fancy_func_2(
            this_needs_to_be_a_long_type_name this_needs_to_be_long_var_name,
            int yet_another_long_var_name) const;

public:
    int_t first_;
    int_t second_;
};

void foo::bar(enum_t val) const
{
    if(true) {
      some_label:
        std::cout << "bar" << std::endl;
    }
    else if(false) {
        ;
    }
    else {
        ;
    }

    switch(val) {
        case enum_t::a:
        {
            break;
        }
        case enum_t::b:
            break;
        case enum_t::c:
            break;
        default:
            break;
    }

    do {
        ;
    } while(false);

    try {
        ;
    }
    catch(...) {
        ;
    }

  some_other_label:
    return;
}

} // foo_bar

int main(int argc, char* argv[])
{
#ifndef SOME_MACRO
    std::cout << "hello, world!"  << " some more random strings, "
            << "even more random strings" << std::endl;
#endif

    SOME_MACRO_DEF(1, 2);

    some_templated_func(
            [=]() {
                if (true) {
                    ;
                }
            },
            2, 3, 4, 5);

    return 0;
}
