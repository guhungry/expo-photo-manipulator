import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoPhotoManipulator.web.ts
// and on native platforms to ExpoPhotoManipulator.ts
import ExpoPhotoManipulatorModule from './ExpoPhotoManipulatorModule';
import ExpoPhotoManipulatorView from './ExpoPhotoManipulatorView';
import { ChangeEventPayload, ExpoPhotoManipulatorViewProps } from './ExpoPhotoManipulator.types';

// Get the native constant value.
export const PI = ExpoPhotoManipulatorModule.PI;

export function hello(): string {
  return ExpoPhotoManipulatorModule.hello();
}

export async function setValueAsync(value: string) {
  return await ExpoPhotoManipulatorModule.setValueAsync(value);
}

const emitter = new EventEmitter(ExpoPhotoManipulatorModule ?? NativeModulesProxy.ExpoPhotoManipulator);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ExpoPhotoManipulatorView, ExpoPhotoManipulatorViewProps, ChangeEventPayload };
