module Coro;

void printMulTable() {
  []<typename Int, Int... LHSs>(std::integer_sequence<Int, LHSs...>) {
    // clang-format off
    ([](Int rhs) {
      std::print("{}{} row: ", rhs + 1,
                 &"st\0nd\0rd\0th"[rhs <= 3 ? (rhs) * 3 : sizeof "st\0nd\0rd"]);
      Int lhs;
      ++rhs;
      ((++(lhs = LHSs), std::print("{} * {} = {:<4}{}", lhs, rhs, lhs * rhs,
                                   "\n"[lhs != 9])),
        ...);
    }(LHSs), ...);
    // clang-format on
  }(std::make_integer_sequence<int, 9>());
}
