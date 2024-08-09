import ExpoPhotoManipulatorModule from "./ExpoPhotoManipulatorModule";
import * as ParamUtils from "./ParamUtils";
import type {
  FlipMode,
  ImageSource,
  PhotoBatchOperations,
  Point,
  Rect,
  RotationMode,
  Size,
  TextOptions,
} from "./PhotoManipulatorTypes";
import { MimeType } from "./PhotoManipulatorTypes";
import type { PhotoManipulatorStatic } from "./privateTypes";

// Import the native module. On web, it will be resolved to ExpoPhotoManipulator.web.ts
// and on native platforms to ExpoPhotoManipulator.ts

const PhotoManipulator: PhotoManipulatorStatic = {
  batch: (
    image: ImageSource,
    operations: PhotoBatchOperations[],
    cropRegion: Rect,
    targetSize?: Size,
    quality = 100,
    mimeType: MimeType = MimeType.JPEG,
  ) => {
    return ExpoPhotoManipulatorModule.batch(
      ParamUtils.toImageNative(image),
      operations.map(ParamUtils.toBatchNative),
      cropRegion,
      targetSize,
      quality,
      mimeType,
    );
  },
  crop: (
    image: ImageSource,
    cropRegion: Rect,
    targetSize?: Size,
    mimeType: MimeType = MimeType.JPEG,
  ) =>
    ExpoPhotoManipulatorModule.crop(
      ParamUtils.toImageNative(image),
      cropRegion,
      targetSize,
      mimeType,
    ),
  flipImage: (
    image: ImageSource,
    mode: FlipMode,
    mimeType: MimeType = MimeType.JPEG,
  ) =>
    ExpoPhotoManipulatorModule.flipImage(
      ParamUtils.toImageNative(image),
      mode,
      mimeType,
    ),
  rotateImage: (
    image: ImageSource,
    mode: RotationMode,
    mimeType: MimeType = MimeType.JPEG,
  ) =>
    ExpoPhotoManipulatorModule.rotateImage(
      ParamUtils.toImageNative(image),
      mode,
      mimeType,
    ),
  overlayImage: (
    image: ImageSource,
    overlay: ImageSource,
    position: Point,
    mimeType: MimeType = MimeType.JPEG,
  ) =>
    ExpoPhotoManipulatorModule.overlayImage(
      ParamUtils.toImageNative(image),
      ParamUtils.toImageNative(overlay),
      position,
      mimeType,
    ),
  printText: (
    image: ImageSource,
    texts: TextOptions[],
    mimeType: MimeType = MimeType.JPEG,
  ) =>
    ExpoPhotoManipulatorModule.printText(
      ParamUtils.toImageNative(image),
      texts.map(ParamUtils.toTextOptionsNative),
      mimeType,
    ),
  optimize: (image: ImageSource, quality: number) =>
    ExpoPhotoManipulatorModule.optimize(
      ParamUtils.toImageNative(image),
      quality,
    ),
};

export default PhotoManipulator;
