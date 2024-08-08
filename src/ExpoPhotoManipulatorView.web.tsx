import * as React from 'react';

import { ExpoPhotoManipulatorViewProps } from './ExpoPhotoManipulator.types';

export default function ExpoPhotoManipulatorView(props: ExpoPhotoManipulatorViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
