import csv

def read_csv():
    with open('./public_methods.csv') as csvfile:
        dictReader = csv.DictReader(csvfile)
        return (list(dictReader))

def update_buzz_booster_dart(method_dict):
    print("update buzz_booster.dart")
    f = open("../lib/buzz_booster.dart", "w")
    
    f.write("import 'buzz_booster_platform_interface.dart';\n\n")
    f.write("class BuzzBooster {\n") 

    for row in method_dict:
        method_name = row["method_name"]
        f.write(f"  Future<void> {method_name}(")

        # add args
        for index in range(0,3):
            args_name_key = (f"args_name{index}")
            args_type_key = (f"args_type{index}")

            args_name = row[args_name_key]
            args_type = row[args_type_key]

            if args_name == None:
                break
            f.write(f"{args_type} {args_name}, ")
        f.write(") {\n")

        f.write(f"    return BuzzBoosterPlatform.instance.{method_name}(")
        # input args
        for index in range(0,3):
            args_name_key = f"args_name{index}"
            args_name = row[args_name_key]

            if args_name == None:
                break

            f.write(f"{args_name}, ")
        
        f.write(f");\n")
        f.write("  }\n")
        f.write("\n")
    f.write("}\n")
    f.close()


def update_buzz_booster_method_channel_dart(method_dict):
    print("update buzz_booster_method_channel.dart")
    f = open("../lib/buzz_booster_method_channel.dart", "w")
    
    f.write("import 'package:flutter/foundation.dart';\n")
    f.write("import 'package:flutter/services.dart';\n")
    f.write("import 'buzz_booster_platform_interface.dart';\n\n")
    f.write("class MethodChannelBuzzBooster extends BuzzBoosterPlatform {\n\n") 

    f.write("  @visibleForTesting\n") 
    f.write("  final methodChannel = const MethodChannel('buzz_booster');\n\n") 
    

    for row in method_dict:
        f.write("  @override\n") 
        method_name = row["method_name"]
        f.write(f"  Future<void> {method_name}(")

        # add args
        for index in range(0,3):
            args_name_key = (f"args_name{index}")
            args_type_key = (f"args_type{index}")

            args_name = row[args_name_key]
            args_type = row[args_type_key]

            if args_name == None:
                break
            f.write(f"{args_type} {args_name}, ")
        f.write(") async {\n")

        f.write(f"    return await methodChannel.invokeMethod<void>(\"{method_name}\", {{\n")
        # input args
        for index in range(0,3):
            args_name_key = f"args_name{index}"
            args_name = row[args_name_key]

            if args_name == None:
                break

            f.write(f"      \"{args_name}\": {args_name},\n")
        
        f.write("    });\n")
        f.write("  }\n")
        f.write("\n")
    f.write("}\n")
    f.close()

def update_buzz_booster_platform_interface_dart(method_dict):
    print("update buzz_booster_platform_interface.dart")
    f = open("../lib/buzz_booster_platform_interface.dart", "w")
    
    f.write("import 'package:plugin_platform_interface/plugin_platform_interface.dart';\n")
    f.write("import 'buzz_booster_method_channel.dart';\n\n")

    f.write("abstract class BuzzBoosterPlatform extends PlatformInterface {\n") 
    f.write("  BuzzBoosterPlatform() : super(token: _token);\n\n") 
    f.write("  static final Object _token = Object();\n\n") 
    f.write("  static BuzzBoosterPlatform _instance = MethodChannelBuzzBooster();\n\n") 
    f.write("  static BuzzBoosterPlatform get instance => _instance;\n\n") 

    f.write("  static set instance(BuzzBoosterPlatform instance) {\n") 
    f.write("    PlatformInterface.verifyToken(instance, _token);\n") 
    f.write("    _instance = instance;\n") 
    f.write("  }\n\n") 

    for row in method_dict:
        method_name = row["method_name"]
        f.write(f"  Future<void> {method_name}(")

        # add args
        for index in range(0,3):
            args_name_key = (f"args_name{index}")
            args_type_key = (f"args_type{index}")

            args_name = row[args_name_key]
            args_type = row[args_type_key]

            if args_name == None:
                break
            f.write(f"{args_type} {args_name}, ")
        f.write(") {\n")

        f.write("    throw UnimplementedError('platformVersion() has not been implemented.');\n")
        f.write("  }\n")
    f.write("\n")
    f.write("}\n")
    f.close()

def add_method():
    print("add method")
    result = read_csv()
    update_buzz_booster_dart(result)
    update_buzz_booster_platform_interface_dart(result)
    update_buzz_booster_method_channel_dart(result)