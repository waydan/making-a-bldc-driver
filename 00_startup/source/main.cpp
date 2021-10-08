#include "nvic_controller.hpp"
#include "switch_functions.h"
#include "systick_utils.h"
#include <cstdint>

int main()
{
    sw2_init();
    sw3_init();

    constexpr IRQ<46> PortA_irq;
    constexpr IRQ<47> PortBCDE_irq;
    NVIC::enable_irq(PortA_irq, PortBCDE_irq);

    systick_init();
    while (true)
        asm("wfi");
}