import std;
import Coro;

using namespace std::literals;

struct Suspend : std::suspend_always {
  Suspend& await_resume(this auto& self) { return self; }
};

std::atomic<std::coroutine_handle<>> ah;

auto coro() -> Task {
  log("Resume on the main thread");
  std::println("{1:👉<20}Resumed on another thread ({0})!{1:👈<20}", co_await schedule(ah), "");
  co_await MulTable{};
  log("Still on the jthread");
  co_await 3s;
  log("Suspended and resumed on the main thread");
  co_await co_await co_await co_await co_await co_await co_await co_await Suspend{};
  co_return log("goto final-suspend, [dcl.fct.def.coroutine]");
}

auto main() -> int {
  auto coro = ::coro();
  {
    auto _ = std::jthread{[] {
      ah.wait({});
      ah.load()();
    }};

    coro();
    [] -> Task { co_await 100us; }()();
    std::println("\n{:=^87}", "Awaiting the jthread.");
  }
  coro()()()()()()()()();
}
