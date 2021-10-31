# Fudge-Finnacial Flutter application


This project is built with flutter version 2.2,3 and dart 2.13.4 please make sure you have a flutter version upper than 2.0.

1. How to install/run the project on a MacBook
    1. Open the project on VS-code or any editor platform you use for flutter development (I go with VS)
    2. Go to the terminal tab below and type flutter pub clean ( just in case )
    3. Now you can run the cmd flutter pub get ( to get all the packages suitable )
    4. Open your favorite simulator / connect your physical device to the system if android then make sure you have the developer option and USB debugging enabled.
    5. Now go to VS-code on the top Menu bar click on the Run tab -> Start without Debugging.
    THE APP STARTS NOW, WELCOME TO THE CLUB....!


2. How is the project implemented?
    1. This project is built with MVC architecture which keeps the file structure understandable and neat. The application is available for both iOS and Android devices to make build for each you can run the cmd:
        i. android: flutter build apk
        ii. iOS: flutter build iOS (make sure you have your certificate and provisioning file)
    2. For managing states on the application Provider package is used which allows us to control the states overall the app as per our needs.
    3. The Line chart shown on the home-page of the app is built using syncfusion_flutter_charts package which was the suitable one regarding the requirements and is also a lightweight package.
    4. As we are also having API integration involved which is done using http package.
    5. To show the loading till the API call returns with the response we have used shimmer package which is a perfect package to show the loading for a particular component and is also rich in look and feels.
    6. You can also find the font ROBOTO being used in the application.


3. Project structure and role
    1. As said above we have used the MVC pattern so the following folders/dir are:
        1. Model:
            Data storage is done here all the data required for the screens are present in this folder.
        2. Provider (Controllers):
            This folder plays an important role in the project it is the brain of the app where it helps to communicate the UI with the data stored in the model by having a reference of each model in the respective provider and sharing the reference with UI (screens). Each provider represents a flow. Some providers which are globally required are initialized in main.dart and others are initialized in their respective files.
        3. Screens (Views):
            This folder contains all the view (UI) which is visible to the end-user here you can find each view has its own dir/folder which represents the UI. Also, each folder for a screen contains a folder (home-page [root]) called component ([child]) which has the widget that is reused for the specific screen folder. This makes the code and structure understandable and the developer doesn't have to jump to another folder just to find a widget connected to the root file of the screen.
        4. Utils:
            All the global colors, assets, variables, functions, fonts used overall the project can be seen here. The reason to add it here was to get it identified uniquely you can get an idea by looking at the file names present in utils.
        5. Widgets:
            This is a part of screens, but the widget which is used globally and not dependent on any screen is present here this can be a universal/generic widget for the whole application.
        6. Services:
            You can find the API class here which is specially made to make API calls the reason to make it separate and not involved in controllers is because some calls can be constantly repeated which can cause redundant of code with minimal code changes and to add more implementation to API calls to make it hybrid we create a new folder with its class in future according to the requirements it can have more files in this dir (ex: api_urls)
        7. Navigators
            Here you can find the code written to add the Fade-In effect to navigate from one screen to another and this is done with the help of FadeTransition class which is wrapped inside the transitionsBuilder and this is a property of PageRouteBuilder which helps us to navigate to other screens. Certain animations, curves, and duration are added to the code which gives the fade transition effect.

# I hope this helps you to understand the code and the workflow.

Author
Karan CK Gore

    

 
