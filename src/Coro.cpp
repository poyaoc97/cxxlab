module Coro;
namespace fs = std::filesystem;

auto log(std::string_view sv, SrcLoc loc) -> void {
  std::println("{}:{} on thread {}> {}.", fs::path(loc.file_name()).filename().c_str(), loc.line(),
               std::this_thread::get_id(), sv);
}

auto Task::operator()() -> Task& {
  if (h && !h.done())
    h();
  else
    std::println("{:😡<10}", "");
  return *this;
}
