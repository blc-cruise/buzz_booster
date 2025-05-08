import re

def add_view_to_plugin(view_name):
    sanke_case_view_name = re.sub(r'(?<!^)(?=[A-Z])', '_', view_name).lower()
    f = open(f"../lib/buzz_booster_{sanke_case_view_name}.dart", "w")
    f.write("import 'package:flutter/widgets.dart';\n")
    f.write("import 'package:flutter/foundation.dart';\n")
    f.write("import 'package:flutter/material.dart';\n")
    f.write("import 'package:flutter/services.dart';\n\n")

    f.write(f"const String viewType = '{view_name}';\n\n")

    # iOS View
    f.write(f"class IOS{view_name} extends StatelessWidget {{\n")
    f.write(f"  @override\n")
    f.write(f"  Widget build(BuildContext context) {{\n")
    f.write(f"    return UiKitView(\n")
    f.write(f"      viewType: viewType,\n")
    f.write(f"      layoutDirection: TextDirection.ltr,\n")
    f.write(f"      creationParams: null,\n")
    f.write(f"      creationParamsCodec: const StandardMessageCodec(),\n")
    f.write(f"    );\n")
    f.write("  }\n")
    f.write("}\n\n")

    # Android View
    f.write(f"class Android{view_name} extends StatelessWidget {{\n")
    f.write(f"  @override\n")
    f.write(f"  Widget build(BuildContext context) {{\n")
    f.write(f"    return AndroidView(\n")
    f.write(f"      viewType: viewType,\n")
    f.write(f"      layoutDirection: TextDirection.ltr,\n")
    f.write(f"      creationParams: null,\n")
    f.write(f"      creationParamsCodec: const StandardMessageCodec(),\n")
    f.write(f"    );\n")
    f.write("  }\n")
    f.write("}\n\n")

    # Dart View
    f.write(f"class {view_name} extends StatelessWidget {{\n")
    f.write(f"  @override\n")
    f.write(f"  Widget build(BuildContext context) {{\n")
    f.write(f"    switch (defaultTargetPlatform) {{\n")
    f.write(f"      case TargetPlatform.android:\n")
    f.write(f"        return Android{view_name}();\n")
    f.write(f"      case TargetPlatform.iOS:\n")
    f.write(f"        return IOS{view_name}();\n")
    f.write(f"      default:\n")
    f.write(f"        throw UnsupportedError('Unsupported platform view');\n")
    f.write("    }\n")
    f.write("  }\n")
    f.write("}\n\n")

    f.close()