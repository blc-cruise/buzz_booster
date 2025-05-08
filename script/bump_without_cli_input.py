import bump_up
import update_sdk_version
import sys

platform = sys.argv[1]
version = sys.argv[2]

if platform == "android":
    bump_up.bump_up_android(bump_up.BUMP_CUSTOM, version)
    update_sdk_version.android_bump_up(version)
elif platform == "ios":
    bump_up.bump_up_ios(bump_up.BUMP_CUSTOM, version)
    update_sdk_version.ios_bump_up(version)
