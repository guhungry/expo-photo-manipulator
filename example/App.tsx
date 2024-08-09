import { StyleSheet, Text, View, Image } from 'react-native';
import { useEffect, useState } from "react";
import { FlipMode, MimeType, RotationMode, PhotoManipulator } from 'expo-photo-manipulator';
import type { PhotoBatchOperations, TextOptions } from 'expo-photo-manipulator/PhotoManipulatorTypes';

export default function App() {
  const [image, setImage] = useState("");
  useEffect(() => {
    let text = [
      {text: "Text", textSize: 32, position: { x: 30, y: 40 }, color: "blue" },
      {text: "Text", textSize: 32, position: { x: 30, y: 40 }, color: "green", thickness: 5 }
    ] as TextOptions[]
    let batch = [
      {operation: "text", options: {text: "Batch Print", textSize: 100, position: { x: 30, y: 40 }, color: "green", thickness: 5 } },
      {operation: "text", options: {text: "Batch Print", textSize: 100, position: { x: 30, y: 40 }, color: "blue" } },
      {operation: "flip", mode: FlipMode.Vertical},
      {operation: "rotate", mode: RotationMode.R90},
      {operation: "overlay", overlay: "https://panel.jamtechtechnologies.com/uploaded_files/technologie/1705392470-11-min.png", position: {x:80, y: 120}}
    ] as PhotoBatchOperations[]

    PhotoManipulator.batch("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", batch, {x: 0, y: 0, width: 1920, height: 1080}, undefined, 100, MimeType.PNG)
    // PhotoManipulator.crop("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", {x: 120, y: 200, width: 300, height: 200}, {width: 50, height: 100}, MimeType.PNG)
    // PhotoManipulator.crop("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", {x: 120, y: 200, width: 300, height: 200}, undefined, MimeType.PNG)
    // PhotoManipulator.flipImage("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", FlipMode.Both, MimeType.PNG)
    // PhotoManipulator.rotateImage("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", RotationMode.R180, MimeType.PNG)
    // PhotoManipulator.overlayImage("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", "https://panel.jamtechtechnologies.com/uploaded_files/technologie/1705392470-11-min.png", {x:80, y: 120}, MimeType.JPEG)
    // PhotoManipulator.printText("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", text, MimeType.JPEG)
    // PhotoManipulator.optimize("https://getwallpapers.com/wallpaper/full/8/d/1/798741-download-free-awesome-nature-backgrounds-1920x1080-for-tablet.jpg", 5)
      .then(it => {console.log(it);setImage(it);})
      .catch(console.error)
  }, []);

  return (
    <View style={styles.container}>
      <Text>{"ExpoPhotoManipulator.hello()"}</Text>
      { image && <Image source={{uri: image}} style={{width: "100%", height: 500, resizeMode: "contain"}} /> }
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
