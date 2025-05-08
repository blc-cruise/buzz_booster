import const

package_root = "com.buzzvil.booster."
android_src_path = const.android_src_path
prefix = const.prefix

file_ext = ".kt"

# Create Android View & Factory
def add_android_view(view_name):
    native_view_path = input(f"Android native view path (root is {package_root}): ")
    path_token = native_view_path.split(".")
    view_name = path_token[len(path_token)-1]
    create_flutter_view(view_name, native_view_path)
    create_flutter_view_factory(view_name)


def create_flutter_view(view_name, view_path):
    f = open(f"{android_src_path}/{prefix}{view_name}{file_ext}", "w")
    f.write("package com.buzzvil.buzz_booster\n")
    f.write("import android.content.Context\n")
    f.write("import android.view.View\n")
    f.write("import io.flutter.plugin.platform.PlatformView\n")    
    f.write(f"import {package_root}{view_path}\n")
    f.write("\n")

    f.write(f"internal class {prefix}{view_name}(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {{\n")
    f.write(f"   private val view: {view_name} = {view_name}(context)\n")
    f.write("\n")
    f.write("   override fun getView(): View {\n")
    f.write("       return view\n")
    f.write("   }\n\n")

    f.write("   override fun dispose() {}\n")
    f.write("}\n")

def create_flutter_view_factory(view_name):
    f = open(f"{android_src_path}/{prefix}{view_name}Factory{file_ext}", "w")
    f.write("package com.buzzvil.buzz_booster\n")
    f.write("import android.content.Context\n")
    f.write("import android.view.View\n")
    f.write("import io.flutter.plugin.common.StandardMessageCodec\n")
    f.write("import io.flutter.plugin.platform.PlatformViewFactory\n")
    f.write("import io.flutter.plugin.platform.PlatformView\n\n")    

    f.write(f"class {prefix}{view_name}Factory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {{\n")
    f.write(f"   override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {{\n")
    f.write("       val creationParams = args as Map<String?, Any?>?\n")
    f.write(f"       return {prefix}{view_name}(context!!, viewId, creationParams)\n")
    f.write("   }\n")
    f.write("}\n")
