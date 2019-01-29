# TheMovieDB

Using open API of themoviedb.org

### Discover
 - Show list of the popular movies using `discovery.`
 - When I scroll​ ​to​ ​the​ ​bottom​ ​of​ ​the list, then​ ​the next​ ​page​ ​should​ ​load​ ​if​ ​available

### Search screen
- When one enters a name of a movie (e.g., "Batman,"​ ​"Rocky")​ ​in​ ​the​ ​search​ ​box​ ​and tap​ ​on​ ​"search" button, then​ ​I​ ​should​ ​see​ ​a​ ​new​ ​list​ ​of movies.
- When​ one taps and​ ​focus​ ​into​ ​the​ ​search​ ​box, hen​ ​an​ ​auto-suggest​ ​list​ ​view​ ​will​ ​display​ ​below​ ​the​ ​search​ ​box​ ​showing​ ​their​ ​last ten​ ​successful​ ​queries​ ​(exclude​ ​suggestions​ ​that​ ​return​ ​errors)
 - When​ ​I​ ​select​ ​a​ ​suggestion, then​ ​the​ ​search​ ​results​ ​of​ ​the​ ​suggestion​ ​will​ ​be​ ​shown.
- When​ ​I​ ​scroll​ ​to​ ​the​ ​bottom​ ​of​ ​the list, then​ ​the next​ ​page​ ​should​ ​load​ ​if​ ​available
- Suggestions​ ​should​ ​be​ ​persisted.

### Details screen
- when tap on the movie on any list the details screen should be shown.

### The Movie cell and detail screen should consist of:
- Movie Poster
- Movie name
- Release date
- Full Movie Overview
___

## Run
To run please open `TheMovieDB.xcworkspace` chose device or simulator and run.
I've kept `Pods` directory to remove the hassle with pod installation etc.


# General Architectural Approach
_a.k.a. what's good about this solution_

I have chosen a MVVM approach with the coordinators and my tiny `Observable` wrapper for binding.

**Good**
- both of the screens consist of movies list, so I wrote it once `Presentation/Movies List`.
- Models of these screens are also different only that search model contains the query, so it was also a good candidate for reuse.
- Inversion of URLSession allows me to test any depending service with ease.
- the design is pretty nice and follows last apple guidelines.

**Might be improved**
- The suggestion model made pretty weak and might be developed in the better way and also should be tested.
- Also, some cool transition might be added.
- Collection view instead of table view would give much more flexibility.
- Naming of course always might be improved.

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
