# TheMovieDB
This app is a client for the The Movie DB (TMDB) API. It allows you to view different types of movie and tv info as well as “favorite” certain content. 

The app was developed using RxSwift, Core Data and the MVVM design pattern.

# Requirements
   * Xcode 12.3 or later
   * Cocoapods 1.10.0 or later
   * Created an account and registered for an API_KEY at The Movie DB https://www.themoviedb.org/documentation/api

# Installation
```
git clone https://github.com/jfischetti/TheMovieDB.git
cd TheMovieDB/
pod install
```

# Running the App
1. Open TheMovieDB.xcworkspace using Xcode
1. Open TheMovieDB/Network/NetworkConstants.swift
1. Locate the api_key value in the defaultRequestParams and replace it with your own.
1. Click on run!

# Running Unit Tests
1. With the workspace open in Xcode, open the Test Navigator
1. To run all tests in the bundle, click the run button that appears to the right of "TheMovieDBTests" bundle.

# Specification
For App architecture design and decisions and user guide, please refer to the specification document. (Specification.pdf)

# Attributions
All movie and tv show data is retrieved using The Movie DB API (www.themoviedb.org).
Icons were retrieved from icons8.com.