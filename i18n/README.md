i18n data contains the Twine file to generate needed translation files for iOS.

## Tools needed

[Twine](https://github.com/scelis/twine)  
Twine is written in Ruby and can be installed via: `gem install twine`

## Generate iOS Strings Files

    twine generate-all-localization-files i18n/i18n.twine pathToSourceDirectory --tags ios --untagged

This happens automatically during the build in Xcode, in the `Run SwiftGen` build phase
