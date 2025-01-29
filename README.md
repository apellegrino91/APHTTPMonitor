# APHTTPMonitor

[![Version](https://img.shields.io/cocoapods/v/APHTTPMonitor.svg?style=flat)](https://cocoapods.org/pods/APHTTPMonitor)
[![License](https://img.shields.io/cocoapods/l/APHTTPMonitor.svg?style=flat)](https://cocoapods.org/pods/APHTTPMonitor)
[![Platform](https://img.shields.io/cocoapods/p/APHTTPMonitor.svg?style=flat)](https://cocoapods.org/pods/APHTTPMonitor)

APHTTPMonitor is a simple HTTP monitoring tool. You just need to add a line of code in your app and navigate to a specific URL on another terminal’s browser. You’ll see a simple and clear webpage with a listing of HTTP requests and the corresponding responses.

This tool was created because:
- You cannot easily see the HTTP traffic of your app with the Xcode Network Monitoring Tool if you’re using a simulator.
- Charles is helpful, but you need to configure SSL proxying, which can be tedious.
- If you need to check the network activity of your app after a long time, you’ll probably lose the connection with the debugger.
- It’s useful if you have to check the HTTP requests made by some third-party libraries in your app.
- If you’re working, it’s really convenient to have all this information on your browser instead of the console or the device itself.

This tool is compatible with Swift and Objective-C and supports iOS 11.0 and later.

## Installation

You can import this library into your project via CocoaPods by adding this line:

```ruby
pod 'APHTTPMonitor'
```

## Usage

You just need to add this line of code when you want to start recording HTTP activity:

```swift
let url = APHTTPMonitor.shared().start()
```

The `url` variable will contain the URL you have to navigate to in your browser.

If you want to stop recording, you can use this useful method:

```swift
APHTTPMonitor.shared().stop()
```

**IMPORTANT!**
This is a debugging tool, so it’s really important to use it only in debug mode. Remember to remove it before submitting to the App Store.

### Useful tips:
- Use the `#ifdef DEBUG` macro to isolate the use of APHTTPMonitor.
- Include the APHTTPMonitor pod in your podfile only in a debug target to avoid importing the pod in production.

## About the author
I’m Antongiulio, a passionate coder with 13+ years of experience from Naples (IT), music, pizza, and football lover, and huge SSC Napoli fan.
