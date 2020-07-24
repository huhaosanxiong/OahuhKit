// Generated using SwiftGen, using my-templete created by Hanson
import UIKit.UIImage
typealias Image = UIImage
@available(*, deprecated, renamed: "ImageAsset")
typealias AssetType = ImageAsset
struct ImageAsset {
fileprivate var name: String
var image: Image {
let bundle = Bundle(for: BundleToken.self)
let image = Image(named: name, in: bundle, compatibleWith: nil)
guard let result = image else { fatalError("Unable to load image named \(name).") }
return result
}
}
enum Asset {
  enum ChatBar {
    static let bubbleBoxLeftN = ImageAsset(name: "bubble_box_left_n")
    static let bubbleBoxRightN = ImageAsset(name: "bubble_box_right_n")
    static let messageAddN = ImageAsset(name: "message_add_n")
    static let messageAddS = ImageAsset(name: "message_add_s")
    static let messageExpressionN = ImageAsset(name: "message_expression_n")
    static let messageExpressionS = ImageAsset(name: "message_expression_s")
    static let messageKeyboardN = ImageAsset(name: "message_keyboard_n")
  }
  static let img1125 = ImageAsset(name: "IMG_1125")
  static let img1145 = ImageAsset(name: "IMG_1145")
  static let img1619 = ImageAsset(name: "IMG_1619")
  static let twitterLogoWhite = ImageAsset(name: "TwitterLogo_white")
  static let background = ImageAsset(name: "background")
  static let netspeedPointer = ImageAsset(name: "netspeed_pointer")
  static let wallhaven578223 = ImageAsset(name: "wallhaven-578223")
}
extension Image {
convenience init!(asset: ImageAsset) {
let bundle = Bundle(for: BundleToken.self)
self.init(named: asset.name, in: bundle, compatibleWith: nil)
}
}
private final class BundleToken {}
