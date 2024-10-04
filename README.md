# Cookbook

## Build Instructions

### Requirements
- **Xcode 16**
- **iOS 17** runtime (simulator or physical device)

### Instructions
1. Clone this repository or download it as a `.zip` file.
2. Open `Cookbook.xcodeproj`. If prompted, trust the project files.
3. Once Xcode finishes indexing the project files, click the run button. Note: The first app install and launch may take a moment.

## About This App

### Features
The Cookbook app lets users explore all of the recipes provided by TheMealDB API! Users can see recipes ranging from desserts to seafood. Your favorite recipes can be bookmarked for later viewing and are even available without a network connection.

### Design Approach
This app follows the MVVM pattern to ensure clear separation of concerns and testability. Protocol-oriented design principles are applied to promote reusability and testability. 

**Network Layer**: 
- HTTP requests are handled by `HTTPService.swift`, conforming to the `HTTPClient` protocol, which allows for easy mocking and unit testing.

**Caching**: 
- `SwiftDataService.swift` manages local caching of recipes, reducing network requests and enabling offline support.

## Future Enhancements
- Implement unit and UI tests, particularly for networking and view model logic.
- Add recipe search functionality to improve user experience.

## Demo
https://github.com/user-attachments/assets/488c42b3-6d54-4013-97a3-a6bd6762aa23

