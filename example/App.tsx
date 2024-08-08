import { StyleSheet, Text, View } from 'react-native';

import * as ExpoPhotoManipulator from 'expo-photo-manipulator';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ExpoPhotoManipulator.hello()}</Text>
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
