#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>

#include <memory>

#include "win32_window.h"

// 一个仅用于承载 Flutter 视图的窗口。
class FlutterWindow : public Win32Window {
 public:
  // 创建一个 FlutterWindow，并在其中运行 |project| 对应的 Flutter 视图。
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window 生命周期回调：
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // 当前要运行的 Flutter 项目。
  flutter::DartProject project_;

  // 当前窗口承载的 Flutter 实例。
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
