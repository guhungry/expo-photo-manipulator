import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoPhotoManipulatorViewProps } from './ExpoPhotoManipulator.types';

const NativeView: React.ComponentType<ExpoPhotoManipulatorViewProps> =
  requireNativeViewManager('ExpoPhotoManipulator');

export default function ExpoPhotoManipulatorView(props: ExpoPhotoManipulatorViewProps) {
  return <NativeView {...props} />;
}
