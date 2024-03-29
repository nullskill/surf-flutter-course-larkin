<!-- PROJECT SHIELDS -->
[![Surf course](https://img.shields.io/badge/Surf-course-blue.svg)](https://education.surf.ru/)
[![Completeness](https://img.shields.io/badge/completeness-100%25-green.svg)](#about-the-project)
[![Flutter Platform](https://img.shields.io/badge/flutter-android%20%7C%20ios-blue.svg)](#about-the-project)


<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/nullskill/surf-flutter-course-larkin">
    <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/res/icons/app/prod.png" alt="Logo" width="120" height="120">
  </a>

  <h3 align="center">Places</h3>

  <p align="center">
    The Surf Flutter development course training project
    <br />
    <a href="https://education.surf.ru/"><strong>Course description »</strong></a>
    <br />
  </p>
</p>



<!-- ABOUT THE PROJECT -->
## About The Project

This is a training project for the Surf practical Flutter development course. It is built using clean architecture approach with the help of MVVM pattern in reactive state management style. The app utilizes CRUD as well as Rest API operations.

### Demo

#### Splash, onboarding and sight list screens (dark theme)
<div>
  <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/splash_and_onboarding.gif" alt="Splash and Onboarding screens" width="220" height="439">
  <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/dark_listview.gif" alt="Dark theme Sight list screen" width="220" height="439">
</div>

<br />
<details>
  <summary>More demo</summary>
  
  #### Favorites, search and filter screens
  <div>
    <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/favorites.gif" alt="Favorites screen" width="220" height="439">
    <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/search.gif" alt="Search screen" width="220" height="439">
    <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/filter.gif" alt="Filter screen" width="220" height="439">
  </div>
</details>
<details>
  <summary>Real device demo</summary>
  
  #### Add sight and map screens
  <div>
    <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/add_sight_screen.gif" alt="Add sight screen" width="362" height="768">
    <img src="https://github.com/nullskill/surf-flutter-course-larkin/blob/master/screenshots/map_screen.gif" alt="Map screen" width="362" height="768">
  </div>
</details>

### Features

Places is for the sight-seeing. You can browse a list of local places to visit, read descriptions and see the photos. You can search for places of interest in the nearby location. Find restaurants, museums, monuments and other. There is a search history on the search screen. Filtering by category and distance is also available. You are able to add your own places of interest with description, coordinates and photos either taken from the camera or album. By selecting the place of choise on the map you can see the card of it, open details or get directions. Every place can be add to or removed from the favorites list. After directions are get on the map the place is included in visited list. Light and dark mode themes can be switched on the settings screen.


### Built With

* [MWWM](https://pub.dev/packages/mwwm) :muscle:
* [Relation](https://pub.dev/packages/relation) :muscle:
* [RxDart](https://pub.dev/packages/rxdart) :muscle:
* [SQLite](https://pub.dev/packages/sqlite3_flutter_libs) :fire:
* [Moor](https://pub.dev/packages/moor) :fire:



<!-- CURRICULUM -->
## Curriculum

<ol>
    <li>First steps
      <ul>
        <li>Course overview</li>
        <li>Setting up the environment</li>
      </ul>
    </li>
    <li>Dart language
      <ul>
        <li>Dart intro</li>
        <li>Variables in Flutter</li>
        <li>Essential data types</li>
        <li>Conditional statements and loops</li>
        <li>Functions</li>
        <li>Classes and interfaces</li>
        <li>Mixins</li>
        <li>Generics</li>
        <li>Asynchronous operations</li>
      </ul>
    </li>
    <li>Flutter. The basics of framework and layout
      <ul>
        <li>Flutter basics</li>
        <li>How to make up a layout</li>
        <li>Handling UI events</li>
        <li>Lists</li>
        <li>Adaptation and stylization</li>
      </ul>
    </li>
    <li>Navigation
      <ul>
        <li>Diving deep in Route and Navigator</li>
        <li>Passing parameters</li>
        <li>Dialogs and bottomsheets</li>
        <li>Named routes</li>
      </ul>
    </li>
    <li>Networking and asynchronous events
      <ul>
        <li>Http, Dio</li>
        <li>Asynchronous events</li>
        <li>Data streams</li>
        <li>Error handling</li>
      </ul>
    </li>
    <li>Architectural patterns
      <ul>
        <li>DI</li>
        <li>Intro to Vanilla, InheritedWidget, Provider architecture</li>
        <li>MobX</li>
        <li>Bloc</li>
        <li>Redux</li>
        <li>MWWM</li>
      </ul>
    </li>
    <li>Animations
      <ul>
        <li>The basics, explicit animations</li>
        <li>Implicit animations</li>
        <li>Hero animations, Route animation</li>
      </ul>
    </li>
    <li>Interaction with the platform
      <ul>
        <li>Data storage</li>
        <li>Writing platform plugins</li>
      </ul>
    </li>
    <li>Preparing for release
      <ul>
        <li>App signing</li>
        <li>Features of the Android project</li>
        <li>Features of the iOS project</li>
      </ul>
    </li>
  </ol>
