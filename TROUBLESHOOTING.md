# iOS build error while `flutter run` 

## Error 1
```sh
Updating local specs repositories
Analyzing dependencies
[!] CocoaPods could not find compatible versions for pod "BuzzBooster":
  In snapshot (Podfile.lock):
    BuzzBooster (= 1.3.5)

  In Podfile:
    buzz_booster (from `.symlinks/plugins/buzz_booster/ios`) was resolved to 0.0.5, which depends on
      BuzzBooster (= 1.4.2)


You have either:
 * changed the constraints of dependency `BuzzBooster` inside your development pod `buzz_booster`.
   You should run `pod update BuzzBooster` to apply changes you've made.
```

### solution
```sh
cd ios
rm Podfile.lock
pod install --repo-update
```


## Error 2
```sh
Launching lib/main.dart on iPhone 11 in debug mode...
Running pod install...                                             875ms
CocoaPods' output:
↳
      Preparing

    Analyzing dependencies

    Inspecting targets to integrate
      Using `ARCHS` setting to build architectures of target `Pods-Runner`: (``)

    Finding Podfile changes
      - Flutter
      - buzz_booster

    Fetching external sources
    -> Fetching podspec for `Flutter` from `Flutter`
    -> Fetching podspec for `buzz_booster` from `.symlinks/plugins/buzz_booster/ios`

    Resolving dependencies of `Podfile`
      CDN: trunk Relative path: CocoaPods-version.yml exists! Returning local because checking is only performed in repo update
      CDN: trunk Relative path: all_pods_versions_1_4_2.txt exists! Returning local because checking is only performed in repo update
      CDN: trunk Relative path: CocoaPods-version.yml exists! Returning local because checking is only performed in repo update

    ――― MARKDOWN TEMPLATE ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

    ### Command

    ```
    /usr/local/bin/pod install --verbose
    ```

    ### Report

    * What did you do?

    * What did you expect to happen?

    * What happened instead?


    ### Stack

    ```
       CocoaPods : 1.11.3
            Ruby : ruby 2.6.8p205 (2021-07-07 revision 67951) [universal.arm64e-darwin21]
        RubyGems : 3.0.3.1
            Host : macOS 12.2 (21D49)
           Xcode : 13.4 (13F17a)
             Git : git version 2.32.1 (Apple Git-133)
    Ruby lib dir : /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib
    Repositories : buzzvil - git - https://github.com/Buzzvil/Specs @ d85325390353c13a58ea00991dd407f3daf6fc29

                   cocoapods - git - https://github.com/CocoaPods/Specs.git @ 2258d29027dae25fa162790e2c3f2903642422c1

                   trunk - CDN - https://cdn.cocoapods.org/
    ```

    ### Plugins

    ```
    cocoapods-binary                   : 0.4.4
    cocoapods-deintegrate              : 1.0.5
    cocoapods-plugins                  : 1.0.0
    cocoapods-search                   : 1.0.1
    cocoapods-trunk                    : 1.6.0
    cocoapods-try                      : 1.2.0
    cocoapods-user-defined-build-types : 0.0.7
    ```

    ### Podfile

    ```ruby
    # Uncomment this line to define a global platform for your project
    platform :ios, '10.0'

    # CocoaPods analytics sends network stats synchronously affecting flutter build latency.
    ENV['COCOAPODS_DISABLE_STATS'] = 'true'

    project 'Runner', {
      'Debug' => :debug,
      'Profile' => :release,
      'Release' => :release,
    }

    def flutter_root
      generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
      unless File.exist?(generated_xcode_build_settings_path)
        raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
      end

      File.foreach(generated_xcode_build_settings_path) do |line|
        matches = line.match(/FLUTTER_ROOT\=(.*)/)
        return matches[1].strip if matches
      end
      raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
    end

    require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

    flutter_ios_podfile_setup

    target 'Runner' do
      use_frameworks!
      use_modular_headers!

      flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
    end

    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
        flutter_additional_ios_build_settings(target)
      end
    end
    ```

    ### Error

    ```
    LoadError - dlopen(/Library/Ruby/Gems/2.6.0/gems/ffi-1.15.5/lib/ffi_c.bundle, 0x0009): tried: '/Library/Ruby/Gems/2.6.0/gems/ffi-1.15.5/lib/ffi_c.bundle' (mach-o file, but is an incompatible architecture (have 'x86_64', need
    'arm64e')), '/usr/lib/ffi_c.bundle' (no such file) - /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.5/lib/ffi_c.bundle
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.5/lib/ffi.rb:5:in `rescue in <top (required)>'
    /Library/Ruby/Gems/2.6.0/gems/ffi-1.15.5/lib/ffi.rb:2:in `<top (required)>'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /Library/Ruby/Gems/2.6.0/gems/ethon-0.15.0/lib/ethon.rb:3:in `<top (required)>'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /Library/Ruby/Gems/2.6.0/gems/typhoeus-1.4.0/lib/typhoeus.rb:2:in `<top (required)>'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/lib/ruby/2.6.0/rubygems/core_ext/kernel_require.rb:54:in `require'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:440:in `download_typhoeus_impl_async'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:372:in `download_and_save_with_retries_async'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:365:in `download_file_async'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:131:in `block (2 levels) in versions'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:124:in `map'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:124:in `block in versions'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:479:in `concurrent_requests_catching_errors'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:121:in `versions'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/specification/set.rb:99:in `block in versions_by_source'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/specification/set.rb:98:in `each'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/specification/set.rb:98:in `each_with_object'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/specification/set.rb:98:in `versions_by_source'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/specification/set.rb:56:in `specification_name'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/cdn_source.rb:216:in `search'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/source/aggregate.rb:83:in `block in search'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/source/aggregate.rb:83:in `select'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-core-1.11.3/lib/cocoapods-core/source/aggregate.rb:83:in `search'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:416:in `create_set_from_sources'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:385:in `find_cached_set'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:360:in `specifications_for_dependency'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:165:in `search_for'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:274:in `block in sort_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:267:in `each'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:267:in `sort_by'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:267:in `sort_by!'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:267:in `sort_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/delegates/specification_provider.rb:60:in `block in sort_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/delegates/specification_provider.rb:77:in `with_no_such_dependency_error_handling'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/delegates/specification_provider.rb:59:in `sort_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolution.rb:754:in `push_state_for_requirements'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolution.rb:744:in `require_nested_dependencies_for'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolution.rb:727:in `activate_new_spec'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolution.rb:684:in `attempt_to_activate'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolution.rb:254:in `process_topmost_state'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolution.rb:182:in `resolve'
    /Library/Ruby/Gems/2.6.0/gems/molinillo-0.8.0/lib/molinillo/resolver.rb:43:in `resolve'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/resolver.rb:94:in `resolve'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer/analyzer.rb:1078:in `block in resolve_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/user_interface.rb:64:in `section'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer/analyzer.rb:1076:in `resolve_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer/analyzer.rb:124:in `analyze'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer.rb:416:in `analyze'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-user-defined-build-types-0.0.7/lib/cocoapods-user-defined-build-types/private_api_hooks.rb:94:in `call'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-user-defined-build-types-0.0.7/lib/cocoapods-user-defined-build-types/private_api_hooks.rb:94:in `block in <class:Installer>'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer.rb:241:in `block in resolve_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/user_interface.rb:64:in `section'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer.rb:240:in `resolve_dependencies'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/installer.rb:161:in `install!'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/command/install.rb:52:in `run'
    /Library/Ruby/Gems/2.6.0/gems/claide-1.1.0/lib/claide/command.rb:334:in `run'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/lib/cocoapods/command.rb:52:in `run'
    /Library/Ruby/Gems/2.6.0/gems/cocoapods-1.11.3/bin/pod:55:in `<top (required)>'
    /usr/local/bin/pod:23:in `load'
    /usr/local/bin/pod:23:in `<main>'
    ```

    ――― TEMPLATE END ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

    [!] Oh no, an error occurred.

    Search for existing GitHub issues similar to yours:
    https://github.com/CocoaPods/CocoaPods/search?q=dlopen%28%2FLibrary%2FRuby%2FGems%2F2.6.0%2Fgems%2Fffi-1.15.5%2Flib%2Fffi_c.bundle%2C+0x0009%29%3A+tried%3A+%27%2FLibrary%2FRuby%2FGems%2F2.6.0%2Fgems%2Fffi-1.15.5%2Flib%2Fffi_c.bun
    dle%27+%28mach-o+file%2C+but+is+an+incompatible+architecture+%28have+%27x86_64%27%2C+need+%27arm64e%27%29%29%2C+%27%2Fusr%2Flib%2Fffi_c.bundle%27+%28no+such+file%29+-+%2FLibrary%2FRuby%2FGems%2F2.6.0%2Fgems%2Fffi-1.15.5%2Flib%2Ff
    fi_c.bundle&type=Issues

    If none exists, create a ticket, with the template displayed above, on:
    https://github.com/CocoaPods/CocoaPods/issues/new

    Be sure to first read the contributing guide for details on how to properly submit a ticket:
    https://github.com/CocoaPods/CocoaPods/blob/master/CONTRIBUTING.md

    Don't forget to anonymize any private data!

    Looking for related issues on cocoapods/cocoapods...

Error output from CocoaPods:
↳
    Searching for inspections failed: undefined method `map' for nil:NilClass

Error running pod install
Error launching application on iPhone 11.
```

### solution
```sh
cd ios
pod install --repo-update
```