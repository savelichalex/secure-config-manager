# secure-config-manager

Create secure config for swift project easily

## Motivation

Create configs for swift project doesn't easy. There is few problems with it.
When you create with public keys, like OAuth tokens, you might don't want to
add it under version control system. If you use git you add this file to `.gitignore`.
But problem with it, that you must add this config to your project for main bundle.
This is problem, becouse your project contain info about file, that doesn't exist in repo.

You of course can create empty plist, add it to project, add it under version control and then
don't track any changes on this file. Something like this `git update-index --assume-unchanged [path]`.
You now can add secret keys, and it not under version control. Good.
Not so fast. Why? Becouse if you revert changes or anything else you lost all your keys.

Another bad option with plist is code obfuscation. If somebody want's to know your keys, then he can easily find it
`ipa` file. Because this is resources!

Another one bad options is type safety. Whith plists you wark with raw data, and need to cast every value. This is awful.

## Solution

Secure-config-manager is easy shell script that get your config (which not under version control) and 
generate code for it. First time they generate empty class with static properties, that is interface of our config. You can easily use it in your code. Script have options that must be embeded to build phases, which generate code with real
data right in compilation and revert changes then.

## Install

Script available in `brew`
```
$ brew install secure-config-manager
```

Go to your project and init `scm`
```
$ scm --init
```

They create few files:
```
.scmrc
config.yml
config.yml.sample
```
And add few lines to `.gitignore`

What is it `.scmrc`. This is settings for `scm`. Of course you might want to set it.
For example if your `.scmrc` file looks like this
```
project_folder: HelloWorld
config_file_name: myconfig.yml
```
Then `scm` will open config file in path `HelloWorld/myconfig.yml`.

Available options:

Option | Description
-------|------------
project_folder | Folder for config
config_file_name | Config file name
target | Generated interface target language (right now only swift available |
gen_interface_name | Name for generated interface

Ok. Now edit your config. For example:
```
myOAuthKey: 12312j3kh12kj3h12jkh3kj12h3kj123hkj123bkj1b23
```

Start `scm` again to generate interface
```
$ scm --generate
```
Now if you not set `gen_interface_name` you can see new generated file `SecretConfig.swift`
They looks like this:
```swift
class SecretConfig {
  static let myOAuthKey: String? = nil
}
```

Add generated file to project and use in code.
```swift
func applicationDidFinishLaunching(aNotification: NSNotification) {
  guard let authKey = SecretConfig.myOAuthKey else {
    return
  }
}
```

Another one step, now go to `Build Phases` in your project and add `Run Script` twice. One place right before
`Compile Sources`, another one at the end.
First phase should contain row `scm -pre`. Second - `scm -post`.

That's all. Now you can easily use secret configs!

# Afterword

secret-config-manager is on early stages, any issues reports and PR are wellcome!

# Roadmap
* generate code for obective-c
* integration with React Native
* Code obfuscation
