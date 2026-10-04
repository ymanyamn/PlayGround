import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';

// ملف مؤقت للمرحلة 1 — سيُستبدل بالكامل في المرحلة 6
// (RootNavigator + ThemeProvider)
export default function App(): JSX.Element {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>TaskFlow — المرحلة 1 تمت ✅</Text>
      <Text>نفّذ npm install ثم npx expo start</Text>
      <StatusBar style="auto" />
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
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 8,
  },
});
