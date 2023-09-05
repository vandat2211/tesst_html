//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_tts/flutter_tts_plugin.h>
#include <simple_animation_progress_bar/simple_animation_progress_bar_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterTtsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTtsPlugin"));
  SimpleAnimationProgressBarPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SimpleAnimationProgressBarPluginCApi"));
}
