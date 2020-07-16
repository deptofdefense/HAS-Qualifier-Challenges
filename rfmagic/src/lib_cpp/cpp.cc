extern "C"
{
#include <malloc.h>
}

void *operator new( unsigned int alloc_size )
{
    return (void *)malloc( alloc_size );
}

void *operator new[]( unsigned int alloc_size )
{
    return (void *)malloc( alloc_size );
}

void operator delete( void *ptr )
{
    free( ptr );
}

void operator delete( void *ptr, size_t nelem )
{
    free( ptr );
}

void operator delete[]( void *ptr )
{
    free( ptr );
}

void operator delete[]( void *ptr, size_t nelem )
{
    free( ptr );
}
