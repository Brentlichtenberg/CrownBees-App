# iOS Project Setup

The Xcode project files need to be generated after cloning. Follow these steps:

1. Make sure you have the JavaScript dependencies installed:
   ```
   cd .. && npm install
   ```

2. Install CocoaPods:
   ```
   cd ios
   pod install
   ```
   
   This will generate the `.xcworkspace` file needed to open in Xcode.

3. Open the workspace in Xcode:
   ```
   open CrownBeesApp.xcworkspace
   ```

## Generating the Full iOS Project

If you need to regenerate the native iOS project files from scratch:

```bash
# From the project root
npx react-native init CrownBeesApp --template react-native-template-typescript --skip-install
```

Then copy the `src/` directory and other JS files from this repository into the newly generated project.
