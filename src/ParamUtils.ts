/**
 * Parameter Utilities Class
 */
import rgba from "color-rgba";
import { Image } from "react-native";

import type {
  Color,
  ImageSource,
  PhotoBatchOperations,
  TextOptions,
} from "./PhotoManipulatorTypes";

/**
 * Convert color string to rgba object
 * @param color
 */
export const toColorNative = (color?: string | Color): Color => {
  if (color !== undefined && typeof color !== "string") {
    return color;
  }

  const result = rgba(color ?? "#000000");
  return {
    r: result[0] ?? 0,
    g: result[1] ?? 0,
    b: result[2] ?? 0,
    a: (result[3] ?? 1) * 255,
  };
};

export const toImageNative = (source: ImageSource): string =>
  typeof source === "string" ? source : Image.resolveAssetSource(source).uri;

export const toTextOptionsNative = (it: TextOptions): TextOptions => ({
  ...it,
  color: toColorNative(it.color),
  thickness: it.thickness ?? 0,
  rotation: it.rotation ?? 0,
  shadowRadius: it.shadowRadius ?? 0,
  shadowColor: it.shadowColor && toColorNative(it.shadowColor),
});

export const toBatchNative = (
  it: PhotoBatchOperations,
): PhotoBatchOperations => {
  if (it.operation === "text") {
    return { ...it, options: toTextOptionsNative(it.options) };
  } else if (it.operation === "overlay") {
    return { ...it, overlay: toImageNative(it.overlay) };
  }
  return it;
};
