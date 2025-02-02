#include <print>
#include <experimental/meta>

constexpr std::meta::info refl = ^^double;

int main() {
    [:refl:] value = 5.0;

    std::println("{}", value);
}
