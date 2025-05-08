import os

def run():
    os.system(f'cd ./example/android/ && fastlane distribution')
    os.system(f'cd ./example/ios/ && fastlane distribution')
