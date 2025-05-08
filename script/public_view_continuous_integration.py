import public_android_view_generator
import public_ios_view_generator
import public_dart_view_generator

def add_view():
    view_name = input("View name:")
    public_android_view_generator.add_android_view(view_name)
    public_ios_view_generator.add_ios_view(view_name)
    public_dart_view_generator.add_view_to_plugin(view_name)