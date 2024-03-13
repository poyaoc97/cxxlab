export module Coro;
import std;
export import :MulTable;

export struct [[nodiscard, clang::coro_return_type, clang::coro_lifetimebound,
                clang::coro_only_destroy_when_complete]] Task {
  struct promise_type {
    auto get_return_object() { return Task{Handle::from_promise(*this)}; }
    auto initial_suspend() noexcept { return std::suspend_always{}; }
    auto final_suspend() noexcept { return std::suspend_always{}; }
    auto unhandled_exception() { std::terminate(); }
    auto return_void() {}
  };
  auto operator()() -> Task&;
  ~Task() { h.destroy(); }

private:
  using Handle = std::coroutine_handle<promise_type>;
  explicit Task(Handle h) : h{h} {}
  Handle h;
};

using SrcLoc = std::source_location;
export auto log(std::string_view = "Running", SrcLoc = SrcLoc::current()) -> void;

export auto schedule(std::atomic<std::coroutine_handle<>>& h) {
  struct Awaiter : std::suspend_always {
    auto await_suspend(this Awaiter& self, std::coroutine_handle<> h) {
      *self.ah = h;
      self.ah->notify_one();
    }
    auto await_resume() { return std::this_thread::get_id(); }
    std::atomic<std::coroutine_handle<>>* ah{};
  };
  return Awaiter{.ah = &h};
}

export template <class Rep, class Period>
auto operator co_await(std::chrono::duration<Rep, Period> d) {
  struct Awaiter {
    std::chrono::high_resolution_clock::duration duration;
    Awaiter(std::chrono::high_resolution_clock::duration d) : duration(d) {}
    bool await_ready() const { return duration.count() <= 0; }
    void await_resume() {}
    void await_suspend(std::coroutine_handle<>) { std::this_thread::sleep_for(duration); }
  };
  return Awaiter{d};
}
