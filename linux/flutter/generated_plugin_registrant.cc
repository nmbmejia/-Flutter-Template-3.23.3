//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <holdable_button/holdable_button_plugin.h>
#include <platform_device_id_linux/platform_device_id_linux_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) holdable_button_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HoldableButtonPlugin");
  holdable_button_plugin_register_with_registrar(holdable_button_registrar);
  g_autoptr(FlPluginRegistrar) platform_device_id_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PlatformDeviceIdLinuxPlugin");
  platform_device_id_linux_plugin_register_with_registrar(platform_device_id_linux_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
