#ifndef RUNNER_UTILS_H_
#define RUNNER_UTILS_H_

#include <string>
#include <vector>

// 为当前进程创建控制台，并将 stdout/stderr 重定向到该控制台，
// 供 runner 和 Flutter 库共同使用。
void CreateAndAttachConsole();

// 接收一个以 UTF-16 编码、且以空字符结尾的 wchar_t*，
// 返回对应的 UTF-8 编码 std::string。失败时返回空字符串。
std::string Utf8FromUtf16(const wchar_t* utf16_string);

// 获取命令行参数，并以 UTF-8 编码的 std::vector<std::string> 返回。
// 失败时返回空数组。
std::vector<std::string> GetCommandLineArguments();

#endif  // RUNNER_UTILS_H_
