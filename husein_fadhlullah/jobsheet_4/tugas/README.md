# Viva La Vida - Lyrics App 🎵

A beautiful Flutter mobile application that displays the lyrics for "Viva La Vida" by Coldplay with stunning animations and modern UI design.

## Features ✨

### 🎨 Beautiful Design
- **Gradient Backgrounds**: Multi-color gradient background with purple and blue tones
- **Modern Typography**: Google Fonts integration with Playfair Display and Open Sans
- **Dark Theme**: Material 3 dark theme for better viewing experience
- **Responsive Layout**: Adapts to different screen sizes

### 🎬 Smooth Animations
- **Rotating Vinyl Record**: Animated vinyl record on the welcome screen that continuously rotates
- **Typewriter Effect**: Song title appears with a typewriter animation
- **Fade Transitions**: Smooth transitions between welcome and lyrics pages
- **Staggered Text Animation**: Lyrics appear with staggered fade-in and slide effects
- **Pulsing Button**: The "View Lyrics" button has a pulsing animation
- **Floating Action Button**: Play/pause button with smooth state transitions

### 📱 User Experience
- **Welcome Screen**: Introduction page with animated elements and branding
- **Scrollable Lyrics**: Full lyrics displayed in a beautiful scrollable interface
- **Highlighted Chorus**: Important lyrics (chorus) are highlighted in bold
- **Back Navigation**: Easy navigation back to the welcome screen
- **Visual Feedback**: Interactive elements provide visual feedback

### 🎵 Content
- Complete lyrics for "Viva La Vida" by Coldplay
- Proper formatting with verses and spacing
- Musical note decorations

## Technical Implementation 🛠️

### Dependencies Used
- `flutter`: Core Flutter framework
- `animated_text_kit`: For typewriter and other text animations
- `google_fonts`: For beautiful typography (Playfair Display & Open Sans)
- `cupertino_icons`: iOS-style icons

### Architecture
- **StatefulWidget**: Main app uses stateful widget for dynamic UI updates
- **Animation Controllers**: Multiple animation controllers for different effects
- **Custom Scrolling**: SliverAppBar with flexible space for enhanced scrolling
- **Gradient Containers**: Custom gradient backgrounds throughout the app

### Key Components
1. **Welcome Page**: Animated intro with vinyl record and typewriter title
2. **Lyrics Page**: Scrollable lyrics with staggered animations
3. **Floating Action Button**: Play/pause simulation
4. **App Bar**: Collapsible app bar with gradient background

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation
1. Clone the repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

### Running the App
```bash
flutter pub get
flutter run
```

## App Structure 📁
```
lib/
  └── main.dart          # Main application file with all components
assets/
  └── images/           # Directory for future image assets
```

## Future Enhancements 🔮
- Audio playback integration
- More songs and artists
- User favorites
- Lyrics synchronization with audio
- Social sharing features
- Custom themes and color schemes

## Screenshots 📸
The app features:
- A rotating vinyl record animation on the welcome screen
- Gradient purple/blue background
- Smooth typewriter animation for the title
- Beautiful scrollable lyrics with fade-in effects
- Modern Material Design 3 interface

---

*Created with ❤️ using Flutter*
