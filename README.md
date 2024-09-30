# 📹 Video Gallery App

The **Video Gallery App** is a simple and intuitive video management application. Users can view a gallery of videos, play them with a single tap, delete them by swiping, and even record new videos. It provides a sleek user experience with easy-to-use features.

## 🛠 Features

- **List of Videos**: See all your uploaded videos on the home screen.
- **Play Video**: Tap on a video thumbnail to play it in fullscreen mode.
- **Delete Video**: Swipe left on a video to delete it.
- **Record Video**: Press the floating camera button to record a new video and upload it to the gallery.
- **Load More Videos**: Automatically load more videos when scrolling to the end of the list.

## 📱 Screenshots

| Home Screen                         | Video Player                     | Recording Screen                 |
|-------------------------------------|----------------------------------|----------------------------------|
| ![Home Screen](path/to/home_screenshot.png)     | ![Video Player](path/to/video_player_screenshot.png) | ![Recording Screen](path/to/recording_screenshot.png) |

## 🔧 Installation

### Prerequisites

Ensure that the following environment variables are set in your `Prod.xconfig` file:

```bash
API_URL = <your-api-url>
API_KEY = <your-api-key>
API_SECRET = <your-api-secret>
CLOUD_NAME = <your-cloud-name>
```


### Steps to Install

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/your-username/video-gallery-app.git
    ```

2. Navigate to the project directory:
    ```bash
    cd video-gallery-app
    ```

3. Add your configuration values in `Prod.xconfig`:
    ```bash
    API_URL = https://your-api-url.com
    API_KEY = your-api-key
    API_SECRET = your-api-secret
    CLOUD_NAME = your-cloud-name
    ```

4. Install the required dependencies:
    ```bash
    swift package update
    ```

5. Open the Xcode project and run the app on a simulator or a real device.

## 🚀 Usage

1. **Home Screen**:
   - The home screen displays a list of videos fetched from your source.
   - You can refresh the list by pulling down on the screen.
   - As you scroll down, more videos are automatically loaded.

2. **Play a Video**:
   - Tap on any video thumbnail to open it in fullscreen mode and start playback.

3. **Delete a Video**:
   - Swipe left on any video to reveal the "Delete" button.
   - Confirm the deletion through an alert prompt.

4. **Record and Upload a Video**:
   - Press the camera button in the bottom-right corner to open the video recorder.
   - Record a new video and upload it to your gallery.

## 🎨 UI Components

- **Video List**: Displays videos in a scrollable list with thumbnails.
- **Video Player**: Plays videos in fullscreen mode.
- **Floating Action Button**: A camera button used to open the video recording screen.
- **Swipe Actions**: Swipe left to delete videos.

## ⚙️ Tech Stack

- **SwiftUI**: For building user interfaces.
- **MVVM (Model-View-ViewModel)**: Architecture pattern used in the app.
- **Combine**: For handling asynchronous data streams and network requests.
- **Moya**: A network abstraction layer used for managing API requests.
- **AlertToast**: For displaying toast notifications during video actions (e.g., success or error messages).

## 🛑 Known Issues

- The video player may sometimes not load certain videos due to invalid URLs.
- On slow networks, the video thumbnails may take a bit longer to load.

## 📝 To-Do

- [ ] Add support for video editing.
- [ ] Add video filters during recording.
- [ ] Implement video search functionality.
- [ ] Improve error handling for failed video uploads.
- [ ] Implement "Load More" feature for infinite scrolling in the video list.

## 👨‍💻 Contributing

If you want to contribute to this project, feel free to fork the repository and submit a pull request. Contributions are always welcome!

1. Fork the project.
2. Create a feature branch:
    ```bash
    git checkout -b feature-name
    ```

3. Commit your changes:
    ```bash
    git commit -m "Add new feature"
    ```

4. Push to the branch:
    ```bash
    git push origin feature-name
    ```

5. Open a pull request.

## 🛡 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## ✨ Acknowledgments

- **Moya** for simplifying the network layer.
- **AlertToast** for the awesome toast notifications used in the app.
- **SwiftUI** community for amazing resources and tutorials.
