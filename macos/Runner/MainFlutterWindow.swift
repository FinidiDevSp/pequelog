import Cocoa

import FlutterMacOS



class MainFlutterWindow: NSWindow {

  override func awakeFromNib() {

    let flutterViewController = FlutterViewController()

    let windowFrame = self.frame

    self.contentViewController = flutterViewController

    self.setFrame(windowFrame, display: true)



    RegisterGeneratedPlugins(registry: flutterViewController)





    self.backgroundColor = NSColor(red: 251.0/255.0, green: 251.0/255.0, blue: 241.0/255.0, alpha: 1.0)

    flutterViewController.view.wantsLayer = true

    flutterViewController.view.layer?.backgroundColor = NSColor(red: 251.0/255.0, green: 251.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor

    super.awakeFromNib()

  }

}

