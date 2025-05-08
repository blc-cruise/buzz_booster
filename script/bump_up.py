import os

YAML_VERSION_KEY = "version:"
YAML_PATH = "./example/pubspec.yaml"
androidVersionFilePath = "./example/android/version.properties"
iosVersionFilePath = "./example/ios/version.properties"

versionCodeKey = 'versionCode'
versionNameKey = 'versionName'

FLUTTER = 1
ANDROID = 2
IOS = 3
ALL = 4

BUMP_MAJOR = 1
BUMP_MINOR = 2
BUMP_PATCH = 3
BUMP_RC = 4
BUMP_CUSTOM = 5

def bumpUpTarget():
    print("bump test app target")
    print("1.flutter")
    print("2.android")
    print("3.ios")
    print("4.all")

def versionHelpMessage():
    print("bump test app version")
    print("1.major")
    print("2.minor")
    print("3.patch")
    print("4.rc")
    print("5.custom")

def parseNewVersionName(versionName: str, command: int):
    major,minor,patch, rc = 0, 0, 0, 0
    try:
        major,minor,patch = versionName.split(".")
    except: 
        main, rc = versionName.split("-")
        major,minor,patch = main.split(".")
    if command == BUMP_MAJOR:
        major = int(major) + 1
        if rc != 0:
            return f'{major}.0.0-{rc}'
        return f'{major}.0.0'
    elif command == BUMP_MINOR:
        minor = int(minor) + 1
        if rc != 0:
            return f'{major}.{minor}.0-{rc}'
        return f'{major}.{minor}.0'
    elif command == BUMP_PATCH:
        patch = int(patch) + 1
        if rc != 0:
            return f'{major}.{minor}.{patch}-{rc}'
        return f'{major}.{minor}.{patch}'
    elif command == BUMP_RC:
        if rc == 0:
            return f'{major}.{minor}.{patch}-rc.0'
        rc_number = int(rc.split(".")[1]) + 1
        return f'{major}.{minor}.{patch}-rc.{rc_number}'
    elif command == BUMP_CUSTOM:
        return versionName
    else:
        raise Exception("Invalid Command")

def generateVersionCode(versionName):
    major,minor,patch = 0, 0, 0
    try:
        major,minor,patch = versionName.split(".")
    except: 
        main, _ = versionName.split("-")
        major,minor,patch = main.split(".")
    if int(minor) < 10:
        minor = '0' + minor
    if int(patch) < 10:
        patch = '0' + patch
    return major + minor + patch

def updateFlutterAppVersion(versionName):
    with open(YAML_PATH) as f:
        lines = f.readlines()
        f.close()

        for idx,line in enumerate(lines):
            if "version:" in line:
                lines[idx] = f"version: {versionName}\n"
        
        result = open(YAML_PATH, "w", encoding='utf-8')
        result.writelines(lines)
        result.close()


def updateTestAppVersion(filePath, versionName, versionCode):
    updatedFile = open(filePath, "w")
    updatedFile.writelines([ 
        f'versionName={versionName}\n',
        f'versionCode={versionCode}'
    ])

def getFlutterAppNewVersion(command):
    file = open(YAML_PATH, "r")
    lines = file.readlines()
    file.close()

    for idx,line in enumerate(lines):
        if YAML_VERSION_KEY in line:
            currentVersionName = line[len(YAML_VERSION_KEY):].strip()
            newVersionName = parseNewVersionName(versionName=currentVersionName, command=command)
            return newVersionName

    raise Exception('Not Found version key in yaml')

def getNewVersion(filePath, command):
    # bump-up android test app
    file = open(filePath, "r")
    lines = file.readlines()
    file.close()

    for line in lines:
        line = line.rstrip("\n") # remove newline in string
        key,value = line.split("=")

        if key == versionNameKey:
            newVersionName = parseNewVersionName(value, command)
            newVersionCode = generateVersionCode(newVersionName)
            return newVersionName, newVersionCode

    raise Exception("get New Version is fail. check your file")

def bump_up_flutter(command, versionName = ""):
    if command == BUMP_CUSTOM and versionName != "":
        updateFlutterAppVersion(versionName = versionName)
        return
    newVersionName = getFlutterAppNewVersion(command=command)
    updateFlutterAppVersion(versionName = newVersionName)

def bump_up_ios(command, versionName = ""):
    if command == BUMP_CUSTOM and versionName != "":
        versionCode = generateVersionCode(versionName)
        updateTestAppVersion(filePath = iosVersionFilePath, versionName = versionName, versionCode = versionCode)
        os.system(f'cd ./example/ios/ && bundle exec fastlane bump version_number:{versionName} build_number:{versionCode}')
        return
    
    newVersionName, newVersionCode = getNewVersion(filePath = iosVersionFilePath, command = command)
    updateTestAppVersion(filePath = iosVersionFilePath, versionName = newVersionName, versionCode = newVersionCode)
    os.system(f'cd ./example/ios/ && bundle exec fastlane bump version_number:{newVersionName} build_number:{newVersionCode}')

def bump_up_android(command, versionName = ""):
    if command == BUMP_CUSTOM and versionName != "":
        versionCode = generateVersionCode(versionName)
        updateTestAppVersion(filePath = androidVersionFilePath, versionName = versionName, versionCode = versionCode)
        return

    newVersionName, newVersionCode = getNewVersion(filePath = androidVersionFilePath, command = command)
    updateTestAppVersion(filePath = androidVersionFilePath, versionName = newVersionName, versionCode = newVersionCode)

def run():
    bumpUpTarget()
    target = int(input())

    versionHelpMessage()
    command = int(input())
    versionName = ""
    if command == BUMP_CUSTOM:
        print("input custom version name eg. 1.0.0")
        versionName = input()


    if command != BUMP_PATCH and command != BUMP_MINOR and command != BUMP_MAJOR and command != BUMP_RC and command != BUMP_CUSTOM:
        raise Exception("Wrong version command")

    if target == FLUTTER:
        bump_up_flutter(command = command, versionName = versionName)
    elif target == ANDROID:
        bump_up_android(command = command, versionName = versionName)
    elif target == IOS:
        bump_up_ios(command = command, versionName = versionName)
    elif target == ALL:
        bump_up_flutter(command = command, versionName = versionName)
        bump_up_android(command = command, versionName = versionName)
        bump_up_ios(command = command, versionName = versionName)
    else:
        raise Exception("Wrong Target")
