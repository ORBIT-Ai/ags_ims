# AGS IMS
Cross Platform Cloud Based Inventory Management System for AGS. Made by Orbit Ai.


# Pre-Requisites
- Android Studio 4.1
- Flutter SDK
- Dart SDK
- Flutter and Dart plugin for Android Studio

# Getting Started
1. Build
   - Open the project in Android Studio
   - Configure Flutter SDK
   - Run `flutter clean` then `flutter pub get` in the terminal.
2. Run
   - Edit build configuration, go to `Run` and select `Edit Configurations` and type `--profile`
     to `Additional arguments` then run `main.dart`.

# Workflow
1. Clone the Project
   ```
   git clone https://github.com/ORBIT-Ai/ags_ims.git
   ```
2. Branch out from develop when creating new branches. 
   Use this branch naming format %TYPE%/%MODULE% 
   - Example:
      - `feature/login`
      - `feature/registration`
   Note: `hotfix` is reserve for production issues.

<img alt="gitflow_workflow" src="https://miro.medium.com/max/1400/1*9yJY7fyscWFUVRqnx0BM6A.png" width="500" height="auto" />

`main` branch = production  
`release` branch = release tagged  
`develop` branch = development 

Make sure to sync your local working branch with develop branch in order to have the latest codes.

1. Switch to a branch
   ```
   git checkout feature/posts (or your working branch)
   ```
2. Create new branch 
   ```
   git checkout -b feature/posts (or your working branch)
   ```
3. Pull from `develop` branch
   ```
   git pull origin develop
   ```
4. Push to your working directory
   ```
   git push -u origin feature/posts (or your working branch) 
   ```

Once done developing the task, create a pull request from your `working` branch to the `develop` branch.

Read more at https://medium.com/devsondevs/gitflow-workflow-continuous-integration-continuous-delivery-7f4643abb64f

# Committing your changes
- Reformat code with `dartfmt` always.
