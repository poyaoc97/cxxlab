export module Coro:MulTable;
import std;
import :MulTable_internal;

export class MulTable {
  friend auto operator co_await(MulTable) {
    struct Awaiter {
      auto await_ready() { return false; }
      auto await_suspend(std::coroutine_handle<>) {
        printMulTable();
        return false;
      }
      auto await_resume() {}
    };
    return Awaiter{};
  }
};
