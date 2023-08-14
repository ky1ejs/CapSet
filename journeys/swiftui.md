#  SwiftUI

_Caveat: I'm  a total n00b to SwiftUI and there are probably many APIs that I don't know how to make use of or know about their existence at all._

## Performance of Photo Picker

The requirements I have of my Photo Picker collection view are
1. Load images quickly
2. Support pinch zooming to view more/less and smaller/larger thumbnails

### Loading Quickly
To load thumbails in a performant manner you should use `PHImageManager`, calling `requestImage` and passing a size that equals the largest size you'll render the image at. The tricky part is that the max image size for you will depend on the max columns you'll support and the width of a given user's screen.

A crude way to handle this would be to calculate for the biggest size screen you could possible support... but this a) may not be viable (e.g. if you're supporting macOS) and b) is wastefull.

A slightly better way of doing this would be to get the given user's `UIScreen` to look up its size, then run your calculation and pass that size down into SwiftUI.  

_whilst writing this piece I played around a bit more with getting the `GeometryReader` to work and managed it by setting the `aspectRatio`. Without this the `LazyVGrid` was unable to figure out the height of items. Realized via [this SO answer](https://stackoverflow.com/questions/64420313/how-to-make-a-lazyvgrid-of-square-images)._ 

Implementing a Photo Picker with `LazyVGrid` led to very slow image loading. Also, every time you popped back to the picker, images would load again.

It turned out that a lot of the loading lag was down to my poor implementation of the page, mainly in these two ways
1. I wasn't using `GeometryReader` to grab the calculated collection view cell size and use it to create smaller cache requests for image 
2. Not using the correct `PHImageManager` API - I was using the one that fetches the full size image

### No peek?
I didn't think you could do force touch peeking with Swift UI. Turns out you can:
https://stackoverflow.com/questions/66435707/how-to-implement-peek-and-pop-in-swiftui

### Animate transition
When the user taps a UICollectionCell, I'd like the selected image to animate to the next screen. I know you can do this in UIKit, but I need to look into whether you can do it in SwiftUI.

 

