#  Deeplink to Instagram and post an image

## Useful links

| Desc | Link | 
| --- | --- | 
| Gives a way to share an local asset id to instagram. Sadly does not seem to support captions | https://github.com/fabricioeus/ShareInstagram/blob/2fe322a626c898077fbe3338c65f25a81a797397/ShareInstagram/ShareInstagram.swift#L25-L64 | 
| Lots of examples on how to post to insta, sadly the caption option doesn't work it seems | https://stackoverflow.com/questions/11393071/how-to-share-an-image-on-instagram-in-ios | 

https://dogusyigitozcelik.medium.com/sharing-feeds-and-stories-to-instagram-with-swift-6162a679d9ce
  

## Deeplinking from an iOS Share Extension
1. Tried passing a URL via `AssetPath` url param, but that seems to be from a time when `ALAssetLibrary` was around (pre iOS 11 it seems)
    a. Also I don't see how one can pass a URL to anywhere but the Photo Library since Instagram won't be sharing any directory access with your app
2. Tried looking up the PHAsset.localIdentifier from the NSExtensionProvider but that doesn't seem possible via the PhotosKit API since you're given a temporary URL and no reference to the local ID to do lookup
    a. I could look into try some of the old look up code that uses deprecated `ALAssetLibary` API (`fetchAssets(withALAssetURLs: [url], options: nil)`), butt hat was deprecated all the way back in iOS 11. 
3. Next up to try is offering a share extension from my share extension, but I wouldn't be surprized if Instagram block that 
    a. In the end this worked... not ideal but an upside is that a) it allows sharing to other apps and b) it allows you to change your insta account before posting
