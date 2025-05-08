import os

YAML_PATH = "./pubspec.yaml"
ANDROID_SDK_VERSION_PATH = "./android/build.gradle"
IOS_PODSPEC_PATH = "./ios/buzz_booster.podspec"

def flutter_bump_up(version):
    with open(YAML_PATH) as f:
        lines = f.readlines()
        f.close()

        for idx,line in enumerate(lines):
            if "version:" in line:
                lines[idx] = f"version: {version}\n"
        
        result = open(YAML_PATH, "w", encoding='utf-8')
        result.writelines(lines)
        result.close()


def android_bump_up(version):
    with open(ANDROID_SDK_VERSION_PATH, 'r') as androidF:
        lines = androidF.readlines()
        androidF.close()

        for idx,line in enumerate(lines):
            if 'implementation ("com.buzzvil:buzz-booster:' in line:
                lines[idx] = f'    implementation ("com.buzzvil:buzz-booster:{version}")\n'

        o = open(ANDROID_SDK_VERSION_PATH, "w", encoding='utf-8')
        o.writelines(lines)
        o.close()

def ios_bump_up(version):
    with open(IOS_PODSPEC_PATH, 'r') as iosF:
        lines = iosF.readlines()
        iosF.close()

        for idx,line in enumerate(lines):
            if "s.dependency 'BuzzBoosterSDK'" in line:
                lines[idx] = f"  s.dependency 'BuzzBoosterSDK', '{version}'\n"
                
            if "s.version" in line:
                lines[idx] = f"  s.version          = '{version}'\n"

        output = open(IOS_PODSPEC_PATH, "w", encoding='utf-8')
        output.writelines(lines)
        output.close()
        os.system('rm -f ./example/ios/Podfile.lock')
        os.system('cd ./example/ios && bundle exec pod install')

def run():
    print("input flutter sdk version eg:1.1.2")
    version = input()

    print("input android native sdk version eg:1.1.2")
    androidSdkVersion = input()

    print("input iOS native sdk version eg:1.1.2")
    iosSdkVersion = input()

    # update Flutter SDK ver.
    flutter_bump_up(version)

    # update Android SDK ver.
    android_bump_up(androidSdkVersion)

    # update iOS SDK ver.
    ios_bump_up(iosSdkVersion)

