# Rotating Widget

A Flutter package that provides a customizable 3D rotating widget with support for touch gestures and gyroscope-based rotation. Perfect for creating interactive UI elements, product showcases, or engaging user experiences.

## Features

✨ **3D Rotation Effects** - Smooth 3D transformations with perspective projection  
🎯 **Touch Gestures** - Rotate widgets by dragging with your finger  
📱 **Gyroscope Support** - Rotate based on device tilt and movement  
⚙️ **Highly Customizable** - Control rotation limits, animations, and behavior  
🔄 **Auto Return** - Optional automatic return to initial position  
🎬 **Initial Animation** - Show users that the widget is interactive  
🚀 **Performance Optimized** - Smooth animations with proper resource management

## Getting Started

Add `rotating_widget` to your `pubspec.yaml`:

```yaml
dependencies:
  rotating_widget: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Basic Usage

### Simple Rotating Widget

```dart
import 'package:rotating_widget/rotating_widget.dart';

RotatingWidget(
  child: Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Center(
      child: Text('Rotate Me!'),
    ),
  ),
)
```

### Touch-Enabled Rotation

```dart
RotatingWidget(
  isToTouchableRotate: true,
  isReturnedStartPosition: true,
  rotationPercentage: 0.2, // 20% of full rotation
  child: YourWidget(),
)
```

### Gyroscope-Based Rotation

```dart
RotatingWidget(
  gyroscopeRotate: true,
  rotationPercentage: 0.15,
  child: YourWidget(),
)
```

### Complete Configuration

```dart
RotatingWidget(
  // The widget to be rotated
  child: YourWidget(),
  
  // Enable touch rotation
  isToTouchableRotate: true,
  
  // Enable gyroscope rotation
  gyroscopeRotate: true,
  
  // Show initial animation hint
  isInitialRotate: true,
  
  // Return to center after interaction
  isReturnedStartPosition: true,
  
  // Maximum rotation (0.0 to 1.0)
  rotationPercentage: 0.15, // 15% of full rotation
)
```

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `child` | `Widget` | **required** | The widget that will be rotated |
| `isToTouchableRotate` | `bool` | `false` | Enable touch-based rotation |
| `gyroscopeRotate` | `bool` | `false` | Enable gyroscope-based rotation |
| `isInitialRotate` | `bool` | `false` | Show initial rotation animation |
| `isReturnedStartPosition` | `bool` | `true` | Return to center after interaction |
| `rotationPercentage` | `double` | `0.15` | Maximum rotation as percentage (0.0-1.0) |

## Gyroscope Support & Platform Compatibility

When using `gyroscopeRotate: true`, the package depends on the `sensors_plus` plugin for gyroscope data.

### Platform Support

| Android |  iOS  | macOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|   ✅   |   ✅   |   ❌   |   ✅*  |   ❌    |    ❌   |

\* Currently it is not possible to set sensors sampling rate on web

### Requirements

- Flutter >=3.19.0
- Dart >=3.3.0 <4.0.0
- iOS >=12.0
- macOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

### iOS Configuration

On iOS you **must** include the `NSMotionUsageDescription` key in your app's `Info.plist` file when using gyroscope features:

```xml
<key>NSMotionUsageDescription</key>
<string>This app uses motion sensors to provide interactive 3D rotation effects.</string>
```

> [!CAUTION]
> Adding `NSMotionUsageDescription` is **required** when using `gyroscopeRotate: true`. Not doing so will crash your app when it attempts to access motion data.

## Examples

### Product Showcase

```dart
RotatingWidget(
  isToTouchableRotate: true,
  isInitialRotate: true,
  rotationPercentage: 0.25,
  child: Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple, Colors.blue],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Center(
      child: Icon(
        Icons.phone_iphone,
        size: 100,
        color: Colors.white,
      ),
    ),
  ),
)
```

### Interactive Card

```dart
RotatingWidget(
  isToTouchableRotate: true,
  gyroscopeRotate: true,
  isReturnedStartPosition: false,
  rotationPercentage: 0.1,
  child: Card(
    elevation: 8,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 50, color: Colors.amber),
          SizedBox(height: 10),
          Text('Interactive Card'),
        ],
      ),
    ),
  ),
)
```

## Performance Tips

- Use reasonable `rotationPercentage` values (0.1-0.3) for best visual results
- The widget automatically manages gyroscope subscriptions and timers
- Animations are optimized with `TweenAnimationBuilder` for smooth performance
- Resources are properly disposed when the widget is removed

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
