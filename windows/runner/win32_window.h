#ifndef RUNNER_WIN32_WINDOW_H_
#define RUNNER_WIN32_WINDOW_H_

#include <windows.h>

#include <functional>
#include <memory>
#include <string>

// 面向高 DPI 场景的 Win32 窗口抽象类。
// 适合被需要自定义渲染和输入处理的子类继承。
class Win32Window {
 public:
  struct Point {
    unsigned int x;
    unsigned int y;
    Point(unsigned int x, unsigned int y) : x(x), y(y) {}
  };

  struct Size {
    unsigned int width;
    unsigned int height;
    Size(unsigned int width, unsigned int height)
        : width(width), height(height) {}
  };

  Win32Window();
  virtual ~Win32Window();

  // 创建一个 Win32 窗口，使用 |title|、|origin| 和 |size| 指定标题、位置和尺寸。
  // 新窗口会创建在默认显示器上。由于传给操作系统的是物理像素，
  // 为了保证视觉尺寸一致，这里会按照默认显示器的缩放比调整宽高。
  // 在调用 |Show| 之前窗口不可见。创建成功时返回 true。
  bool Create(const std::wstring& title, const Point& origin, const Size& size);

  // 显示当前窗口。显示成功时返回 true。
  bool Show();

  // 释放与窗口关联的操作系统资源。
  void Destroy();

  // 将 |content| 插入当前窗口树中。
  void SetChildContent(HWND content);

  // 返回底层窗口句柄，供调用方设置图标等窗口属性。
  // 如果窗口已经销毁，则返回 nullptr。
  HWND GetHandle();

  // 为 true 时，关闭该窗口会同时退出应用。
  void SetQuitOnClose(bool quit_on_close);

  // 返回一个表示当前客户区边界的 RECT。
  RECT GetClientArea();

 protected:
  // 处理与鼠标、尺寸变化、DPI 等相关的关键窗口消息，
  // 并将可扩展的处理逻辑交给子类覆写实现。
  virtual LRESULT MessageHandler(HWND window,
                                 UINT const message,
                                 WPARAM const wparam,
                                 LPARAM const lparam) noexcept;

  // 在创建窗口时调用，供子类执行窗口相关初始化。
  // 如果初始化失败，子类应返回 false。
  virtual bool OnCreate();

  // 在调用 Destroy 时触发。
  virtual void OnDestroy();

 private:
  friend class WindowClassRegistrar;

  // 消息循环调用的操作系统回调。
  // 它会处理 WM_NCCREATE，以便在创建非客户区时启用自动 DPI 缩放，
  // 让非客户区能自动响应 DPI 变化；其余消息交由 MessageHandler 处理。
  static LRESULT CALLBACK WndProc(HWND const window,
                                  UINT const message,
                                  WPARAM const wparam,
                                  LPARAM const lparam) noexcept;

  // 获取与 |window| 关联的类实例指针。
  static Win32Window* GetThisFromHandle(HWND const window) noexcept;

  // 更新窗口边框主题，使其与系统主题保持一致。
  static void UpdateTheme(HWND const window);

  bool quit_on_close_ = false;

  // 顶层窗口句柄。
  HWND window_handle_ = nullptr;

  // 承载内容的子窗口句柄。
  HWND child_content_ = nullptr;
};

#endif  // RUNNER_WIN32_WINDOW_H_
