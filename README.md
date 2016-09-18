Custom On/Off Animated UIButton, written in Swift. By Creativedash
===========

[![Version](https://img.shields.io/cocoapods/v/OnOffButton.svg?style=flat)](http://cocoapods.org/pods/OnOffButton)
[![License](https://img.shields.io/cocoapods/l/OnOffButton.svg?style=flat)](http://cocoapods.org/pods/OnOffButton)
[![Platform](https://img.shields.io/cocoapods/p/OnOffButton.svg?style=flat)](http://cocoapods.org/pods/OnOffButton)

## About
This control is inspired on this Creative Dash dribbble:
![alt tag](https://d13yacurqjgara.cloudfront.net/users/107759/screenshots/1631598/onoff.gif)

## Swift Upgrade

Use tags to fit your Swift version:

Swift 3   => `1.4`

Swift 2.3 => `1.3`

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "rakaramos/OnOffButton"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

### [CocoaPods]

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'OnOffButton'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.


### Manually
Just copy the `OnOffButton.swift` into your project.

## Implementation

After the installation, you can use it straight in code or with xib/storyboard.

### In code:

```swift
class ViewController: UIViewController {
    
    let onOffButton = OnOffButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onOffButton.frame = CGRect(origin: .zero, size:CGSize(width: 100,height: 100))
        // Adjust properties
        onOffButton.lineWidth = 5
        onOffButton.strokeColor = .whiteColor()
        onOffButton.ringAlpha = 0.3
        onOffButton.addTarget(self, action: #selector(ViewController.didTapOnOffButton), forControlEvents: .TouchUpInside)
        
        view.addSubview(onOffButton)
    }
    
    func didTapOnOffButton() {
        onOffButton.checked = !onOffButton.checked
    }
}
```

### Using `@IBDesignables`

Set the `UIButton` class to use `OnOffButton`:

![alt tag](https://cloud.githubusercontent.com/assets/7672056/14966575/95d2de1e-1089-11e6-8e22-6beb549c806b.png)

Configure the properties as you want: 

![alt tag](https://cloud.githubusercontent.com/assets/7672056/14966574/95d082cc-1089-11e6-9ef7-8215e390bb19.png)

Create an `IBAction`:

```swift
@IBAction func changeButtonState(sender: OnOffButton) {
    sender.checked = !sender.checked
}
```


Profit ;)

## License
Released under the MIT license. See the LICENSE file for more info.
