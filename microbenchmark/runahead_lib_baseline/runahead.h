#ifndef RUNAHEAD_H
#define RUNAHEAD_H

#ifndef BASELINE

#define runahead_to(label) \
    asm volatile("jre %l0" :: "i"(&&label) : "memory")

#define runahead_fence() \
    asm volatile("fence.re.end" ::: "memory")
#else
#define runahead_to(label) \
    asm volatile("nop" ::: "memory")

#define runahead_fence() \
    asm volatile("nop" ::: "memory")

#endif

#endif // RUNAHEAD_H
