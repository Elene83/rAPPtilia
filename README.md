# rAPPtilia

## About 

rAPPtilia is an iOS application created to raise awareness about one of the most important animal classes of the ecosystem, class reptilia, otherwise known as reptiles. The application was built to help users track reptile sightings in Georgia while promoting conservation through education about reptile behavior, habitat, activity, safety around them, and the importance of protecting these often-misunderstood and heavily scrutinized creatures. The app includes every species of reptiles that have been recorded in Georgia, each presented with images, characterization and important information.

## Target Audience

- Hikers and nature lovers who frequently explore Georgia's outdoors 
- Residents of rural areas and villages who regularly encounter reptiles 
- Anyone curious about the reptiles in their surroundings 
- People who want to learn how to safely coexist with local wildlife 
- Those interested in contributing to reptile conservation efforts

## Features

- **Interactive Map** - Real time location, ability to add and see others' tracked reptiles
- **AI Chatbot** - Versed in Georgian fauna, ability to give crucial information
- **Species Database** - Created specifically for rAPPtilia, based on reliable sources 
- **Location Logging** - Adding locations of reptile sightings
- **Account Management** - Storing locations, favorite reptiles, changing account password, username or full name, deleting the account
- **Dark Mode Support** - Local/system based theme, based on user preference

## Screenshots

[Screenshots coming soon]

## Technologies Used

- **Swift** - Primary programming language
- **UIKit** - Core UI framework, viewcontrollers
- **SwiftUI** - UI components and views
- **MapKit** - Interactive map display and location services
- **Core Location** - GPS and location tracking
- **Firebase Authentication** - Secure user login and account management
- **Firebase Firestore** - Real-time database for storing observations and reptile data
- **Firebase Storage** - Cloud storage for images used
- **Firebase Vertex AI** - Used for a real-time chatbot

## Architecture 

Built using **MVVM + Clean Architecture** for maintainable, testable code with clear separation between UI, business logic, and data layers.

## Requirements

- **Deployment Target** - iOS 18.6
- **Xcode Version** - 16.3
- **Device** - iOS only
- **Permissions** - Location access 
- **Internet Connection** - Required for Firebase  

## Installation

1. Clone the repository
2. Open the project in Xcode
3. The app uses a shared Firebase database - the `GoogleService-Info.plist` file is included
4. Build and run (⌘ + R)

## Author

Elene Dgebuadze

## Acknowledgments

- Reptile species information based on research from *Remarks of herpetofauna of the Caucasian Republic of Georgia* by Herman A.J. in den Bosch and Wolfgang Bischoff
- UI/UX design by me - [available on Figma](https://www.figma.com/design/XQgMDXxoRR7zp4eHXgeeT9/rAPPtilia?node-id=0-1&p=f&t=Gt7GsqArJoiKEzMc-0)
- Custom fonts: Firago font family
- Multiple icons from SVGRepo
