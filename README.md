# NJPicker
[SwiftUI] Number / Text Picker (Can be used as a timer)

You can easily enter an emoji using the emoji picker. Available only in ios version 13.0 and later.

## Usage

```swift
import NJPicker

...

NJPicker($selectedItem,
          data: ["1","2","3"],
          defaultValue: 0,
          hapticStyle: .light)
```


## Installation

In Xcode go to `File -> Swift Packages -> Add Package Dependency` and paste in the repo's url: `https://github.com/nasneyland/NJPicker`
