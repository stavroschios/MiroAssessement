# GitHub Profile Search

A SwiftUI app for searching GitHub users and viewing their profiles, followers, and following lists. This project was completed as part of the Speer Technologies iOS assessment.

## Time Spent
**Total Time: 3h 20min**

## Features

- **Search GitHub Users**: Search for any GitHub user by username
- **User Profiles**: View detailed user information including:
  - Avatar
  - Username
  - Name
  - Description/Bio
  - Follower count
  - Following count
- **Follower/Following Lists**: Navigate to see a user's followers and who they're following
- **Navigation**: Smooth navigation between profiles, with the ability to navigate backwards

### Bonus Features Implemented
- **Skeleton Screens**: Loading placeholders while content is being fetched
- **Pull to Refresh**: Update data with pull gesture
- **Profile Caching**: Efficient caching and loading of avatars and profile data

## Architecture

This app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Define data structures for GitHub users and responses
- **ViewModels**: Handle business logic, API calls, and state management
- **Views**: Display UI and bind to ViewModels
- **Services**: Handle network requests to GitHub API

The implementation adheres to SOLID principles with proper separation of concerns.

## Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **Combine**: For reactive programming and data flow
- **Async/await**: For clean asynchronous network calls
- **NavigationStack**: For advanced navigation
- **NSCache**: For efficient image and data caching

## Project Structure

- `Models/`: Data models for GitHub entities
- `ViewModels/`: View models for business logic
- `Views/`: SwiftUI views and components
- `Services/`: Network and API service layers
- `Utils/`: Helper utilities, constants, and extensions

## Running the App

1. Clone the repository
2. Open the project in Xcode
3. Build and run on a simulator or device (iOS 16.0+)

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+ 