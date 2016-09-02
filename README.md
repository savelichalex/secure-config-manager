# secure-config-manager

Create secure config for swift project easily

## Motivation

Creating configs for swift project is not an easy task. There are few problems with it.
When configs contain public keys, like OAuth tokens, probably you don't want to
put them under version control system. If you use git you may add this file to `.gitignore`.
But also you have to add this config to your project into the main bundle.
That is a problem, because your project contains info about file, that doesn't exist in repo.

Of course you can create empty plist, add it to the project, put it under version control and then
not track any changes of this file. This will look similar to this: `git update-index --assume-unchanged [path]`.
Now you can add secret keys, and it's not under version control. Good.
Not so fast. Why? Because if you revert changes or anything else you'll lost all your keys.

Another bad option with .plist is a code obfuscation. If someone wants to get your keys, he can easily find them in
`.ipa` file, because .plist is a resource!

Another bad option is type safety. Plists work with raw data, and you need to cast its every value. This is awful.

## Solution

Secure-config-manager is a simple shell script that gets your config (which is not under version control) and
generates code for it. At first time it generates an empty class with static properties -- that is an interface of our config. You can easily use it in your code. This script has options that must be embedded in build phases in order to generate code with real data during the compilation and have possibility to revert changes.

## Install

You can install with `brew`
```
$ brew install https://raw.githubusercontent.com/savelichalex/secure-config-manager/master/secure-config-manager.rb
```

Go to your project and init `scm`
```
$ scm --init
```

It will create few files:
```
.scmrc
config.yml
config.yml.sample
```
And add few lines to `.gitignore`

What is `.scmrc`? It is settings for `scm`. Of course you might want to set it.
For example, your `.scmrc` file can look like this:
```
project_folder: HelloWorld
config_file_name: myconfig.yml
```
Then `scm` will open config file located at path `HelloWorld/myconfig.yml`.

Available options:

Option | Description
-------|------------
project_folder | Folder for config
config_file | Config file name (file must be in YAML format, <br/>but this field is just a name, i.e. for file <br/>`myconf.yml` the name is `myconf`)
target | Generated interface target language (right now only swift is available |
gen_interface_name | Name for generated interface

Ok. Now edit your config. For example:
```
myOAuthKey: 12312j3kh12kj3h12jkh3kj12h3kj123hkj123bkj1b23
```

Start `scm` again to generate interface
```
$ scm --generate
```
Now if you did not set `gen_interface_name` you can see new generated file `SecretConfig.swift`
It looks like this:
```swift
class SecretConfig {
  static let myOAuthKey: String? = nil
}
```

Add generated file to the project and use it in code.
```swift
func applicationDidFinishLaunching(aNotification: NSNotification) {
  guard let authKey = SecretConfig.myOAuthKey else {
    return
  }
}
```

Next step. Now go to `Build Phases` in your project and add `Run Script` twice. Place first right before
`Compile Sources`, place second at the end.
First phase should contain row `scm -pre`. Second - `scm -post`.

That's all. Now you can easily use secret configs!

# Afterword

secret-config-manager is on early stages, any issue reports and PR are wellcome!

# Roadmap
* generate code for obective-c
* integration with React Native
* Code obfuscation
