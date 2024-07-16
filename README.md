#  MediaItemArtworkTest
A project to demonstrate memory problems that occur when accessing album artwork using 3 [Media Player framework](https://developer.apple.com/documentation/mediaplayer/) methods. 

## How to recreate memory leak

 1. Grant media library access
 2. Scroll through ~100+ albums
 3. Observe steady memory increase in Xcode Debug navigator and crash as you scroll and new artwork is loaded

## Get Artwork Method Notes

 1. **Artwork Image** releases memory sometimes if the images are small and you scroll slow, but will still accumulate memory to the point of dropping frames when scrolling.
 2. **Value For Property** behaves similar to Artwork Image even when using the implicit size of the artwork bounds.
 3. **Image From Disk** problem seems related to perform() method since you can remove UIImage and memory still accumulates
 4. **All 3 methods** result in higher retain counts than expected for artwork objects that could be preventing memory from releasing

## Goals
1. Use MediaPlayer framework to get artwork images (not MusicKit)
2. Release artwork memory so that scrolling is smooth and app does not crash
