#  SwiftUI

_Caveat: I'm  a total n00b to SwiftUI and there are probably many APIs that I don't know how to make use of or know about their existence at all._

### Performance of Photo Picker

Implementing a Photo Picker with `LazyVGrid` led to very slow image loading. Also, every time you popped back to the picker, images would load again.

It turned out that a lot of the loading lag was down to my poor implementation of the page, mainly in these two ways
1. I wasn't using `GeometryReader` to grab the calculated collection view cell size and use it to create smaller cache requests for image 
2. Not using the correct `PHImageManager` API - I was using the one that fetches the full size image

### No peek?
I didn't think you could do force touch peeking with Swift UI. Turns out you can:
https://stackoverflow.com/questions/66435707/how-to-implement-peek-and-pop-in-swiftui

### Animate transition
When the user taps a UICollectionCell, I'd like the selected image to animate to the next screen. I know you can do this in UIKit, but I need to look into whether you can do it in SwiftUI.

 

