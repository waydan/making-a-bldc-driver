#ifndef STARTUP_EXAMPLE_NVIC_CONTROLLER_HPP
#define STARTUP_EXAMPLE_NVIC_CONTROLLER_HPP

#include <cassert>
#include <cstdint>
#include <type_traits>

template <typename T>
using remove_cvref = std::remove_cv_t<std::remove_reference_t<T>>;

template <unsigned char vector>
struct IRQ {};

struct NVIC {
    // Interrup Set-Enable Register @ 0xE000_E100
    static std::uint32_t volatile* const ISER;
    // Interrup Clear-Enable Register @ 0xE000_E100
    static std::uint32_t volatile* const ICER;
    // Interrup Set-Pending Register @ 0xE000_E100
    static std::uint32_t volatile* const ISPR;
    // Interrup Clear-Pending Register @ 0xE000_E100
    static std::uint32_t volatile* const ICPR;
    // Interrup Priority Registers @ 0xE000_E100
    static std::uint32_t volatile* const IPR;

    template <unsigned char... vectors>
    static void enable_irq(IRQ<vectors>...) noexcept
    {
        static_assert(((vectors >= 16) and ...),
                      "only vectors greater than 16 may be enabled/disabled");
        *ISER = ((1u << (vectors - 16)) | ...);
    }
};

inline std::uint32_t volatile* const NVIC::ISER =
    reinterpret_cast<std::uint32_t*>(0xE000'E100);
inline std::uint32_t volatile* const NVIC::ICER =
    reinterpret_cast<std::uint32_t*>(0xE000'E180);
inline std::uint32_t volatile* const NVIC::ISPR =
    reinterpret_cast<std::uint32_t*>(0xE000'E200);
inline std::uint32_t volatile* const NVIC::ICPR =
    reinterpret_cast<std::uint32_t*>(0xE000'E280);
inline std::uint32_t volatile* const NVIC::IPR =
    reinterpret_cast<std::uint32_t*>(0xE000'E100);


#endif // STARTUP_EXAMPLE_NVIC_CONTROLLER_HPP