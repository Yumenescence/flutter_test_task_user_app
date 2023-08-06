# flutter_test_task

**Flutter Test Task** is a simple Flutter application developed to demonstrate data pagination and local caching.

## Description
This project is a simple app that allows you to browse a list of users divided into pages. User data is fetched from a remote server, and when there is an internet connection, it is cached locally for offline use.

## Requirements
To run and develop this project, you will need the following components:

* Flutter SDK: >=2.12.0 <3.0.0
* Android Studio or Xcode (for running on Android or iOS devices)

## Installation
To install the project, follow these steps:

1. Clone the repository using Git:
```git clone <repository URL>```
2. Navigate to the project directory:
```cd flutter_test_task```
3. Install the dependencies:
```flutter pub get```

## Running
To run the application, execute the command:
```flutter run```

## Usage
After running the app, you will see a list of users. You can scroll down to load more users, as the data is paginated.

If you have an internet connection, user data will be fetched from the remote server. If you disconnect the internet and restart the app, the data will be loaded from the local cache if it was previously saved.
