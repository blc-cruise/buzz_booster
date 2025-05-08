import const

ios_src_path = const.ios_src_path
prefix = const.prefix
h_file_ext = ".h"
m_file_ext = ".m"

# Create iOS View & Factory
def add_ios_view(view_name):
    create_flutter_view_header(view_name)
    create_flutter_view_implementation(view_name)


def create_flutter_view_header(view_name):
    f = open(f"{ios_src_path}/{prefix}{view_name}Factory+View{h_file_ext}", "w")
    f.write("#import <Flutter/Flutter.h>\n")
    f.write("#import <BuzzBooster/BuzzBooster.h>\n")
    f.write("\n")

    f.write(f"@interface {prefix}{view_name}Factory : NSObject <FlutterPlatformViewFactory>\n")
    f.write("- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;\n")
    f.write("@end\n")
    f.write("\n")

    f.write(f"@interface {prefix}{view_name} : NSObject <FlutterPlatformView>\n")
    f.write("- (instancetype)initWithFrame:(CGRect)frame\n")
    f.write("               viewIdentifier:(int64_t)viewId\n")
    f.write("                    arguments:(id _Nullable)args\n")
    f.write("              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;\n")
    f.write("\n")
    f.write("- (UIView*)view;\n")
    f.write("\n")
    f.write("@end\n")
    f.write("\n")

def create_flutter_view_implementation(view_name):
    f = open(f"{ios_src_path}/{prefix}{view_name}Factory+View{m_file_ext}", "w")
    
    f.write(f"#import \"{prefix}{view_name}Factory+View{h_file_ext}\"\n\n")
    f.write(f"@implementation {prefix}{view_name}Factory {{\n")
    f.write("  NSObject<FlutterBinaryMessenger>* _messenger;\n")
    f.write("}\n")
    f.write("\n")

    f.write("- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {\n")
    f.write("  if (self = [super init]) {\n")
    f.write("    _messenger = messenger;\n")
    f.write("  }\n")
    f.write("  return self;\n")
    f.write("}\n")
    f.write("\n")

    f.write("- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame\n")
    f.write("                                   viewIdentifier:(int64_t)viewId\n")
    f.write("                                        arguments:(id _Nullable)args {\n")
    f.write(f"  return [[{prefix}{view_name} alloc] initWithFrame:frame\n")
    f.write("                              viewIdentifier:viewId\n")
    f.write("                                   arguments:args\n")
    f.write("                             binaryMessenger:_messenger];\n")
    f.write("}\n")
    f.write("\n")
    f.write("@end\n")
    f.write("\n")

    f.write(f"@implementation {prefix}{view_name} {{\n")
    f.write(f"  BST{view_name} *_view;\n")
    f.write("}\n")
    f.write("\n")
    f.write("- (instancetype)initWithFrame:(CGRect)frame\n")
    f.write("               viewIdentifier:(int64_t)viewId\n")
    f.write("                    arguments:(id _Nullable)args\n")
    f.write("              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {\n")
    f.write("  if (self = [super init]) {\n")
    f.write(f"    _view = [[BST{view_name} alloc] init];\n")
    f.write("  }\n")
    f.write("  return self;\n")
    f.write("}\n")
    f.write("\n")

    f.write("- (UIView *)view {\n")
    f.write("  return _view;\n")
    f.write("}\n")
    f.write("\n")
    f.write("@end\n")
    f.write("\n")
