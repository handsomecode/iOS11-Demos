# Drag and Drop

An example of how to use the Drag and Drop API to copy information from one collection view to another.


<img src="multi_drag_drop.gif">

Drag and Drop is an extremely powerful feature for iOS.  Being able to seamlessly drop data into one app from another and have it "just work" is one of the best user experience updates made to the platform in a long while.

Being able to support this in applications is more than likely going to become a community standard amongst applications.  You likely won't notice the apps that do support Drag and Drop but you will remember the ones that don't.  Users will come to expect an image app to support dropping (and most likely also dragging to) images from other applications.

### Usage
#### Collection (and Table) Views
Everything discussed below about collection views also applies to table view using the `UITableViewDragDelegate`
###### Drag
Incorporating the Drag functionality into a collection view is remarkably easy.  Simply conform to `UICollectionViewDragDelegate`, set your controller as the `dragDelegate` of the collection view, enable `dragInteractionEnabled` on the collection view, and implement the required function:
```swift
// Tells the new drag session what it will be dragging
func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let color = colors[indexPath.item]
    let dragItem = UIDragItem(itemProvider: NSItemProvider(object: color))
    dragItem.localObject = color

    return [dragItem]
}
```
This is the only required function the drag delegate must implement but you can only leverage the true customization powers of Drag by using the optional functions.  During the WWDC sessions on Drag and Drop, the Apple engineers strongly urged developers to use the optional function whenever possible to give a rich, custom user experience in your app.

###### Drop
Adding Drop functionality to a collection view is just as easy as adding Drag.  Have your collection view conform to `UICollectionViewDropDelegate`, set your controller as the `dropDelegate`, and implement the required function:
```swift
func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    // Get destination index path
    // Batch update the collection view
    // Update data sources
    // Drop item in collection view
}
```
Just as with Drag, this is the only required function the drop delegate must implement but you can fully customize the experience by implementing the optional functions.

And that's it.  Two functions and three collection/table view properties and you can support Drag and Drop in your application's table or collection view!

#### Standalone elements
Coming Soon!

### Documentation
[Drag and Drop](https://developer.apple.com/documentation/uikit/drag_and_drop)

[NSItemProvider](https://developer.apple.com/documentation/foundation/nsitemprovider)

[Apple Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/interaction/drag-and-drop/)
