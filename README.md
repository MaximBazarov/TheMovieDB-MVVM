# TheMovieDB
TheMovieDB.org iOS App (Simple MVVM)

To run please open `TheMovieDB.xcworkspace` chose device or simulator and run.
I've kept `Pods` directory to remove the hassle with pod installation etc.

## Project  structure

```

├── Source    # all the source code
├── Tests     # tests
├── Resources # plist and resources
└── Pods      # to make building and running easier
```

### The `Source` folder consists of:

I structure the code by layers, so each layer represented by folder and each subfolder is an entity of that layer.


#### Application
  Application layer `AppDelegate` etc.  Usually, here I create Dependency Container and the main router (coordinator) to coordinate screen presentation and injecting dependencies into the services and screens.

#### Domain

Domain layer consists of structures that can be used everywhere in the application such as `Movie` as these entities are the part of the knowledge domain, so-called objects from the real world.

#### Presentation

Presentation layer only consists of Views (screens) and their View models.

#### Services
Service layer contains all services, classes that do work (usually in the background) and provide data to the application. Here are only API and Storage.

## General Architectural Approach

I have chosen a MVVM approach with the coordinators and my tiny `Observable` wrapper for binding.

## Third part dependencies

I only used `Nuke` for image from url downloading to save me tons of time and I hope this is not the idea of code challenge.

## Tests

I am sorry, during the time pressure I tried to comprehend the UI and MVVM and tested only the business logic and not all the cases, my general strategy here is to test the main cases and add cases for bugs is happened.

Have fun reviewing it!
And I'm looking forward to hearing your feedback on this.

