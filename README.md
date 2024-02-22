# InvisibleInk

The goal of this project is to recreate the **Invisible Ink** effect of the iMessage app.

## Preview

Here's how it looks so far:

https://github.com/sonnyfournier/InvisibleInk/assets/16129249/b8de429b-6c17-48f2-b1d5-03b8de4d903b

https://github.com/sonnyfournier/InvisibleInk/assets/16129249/09d0dae8-4daa-45f0-a93b-8127ee062178

https://github.com/sonnyfournier/InvisibleInk/assets/16129249/75b1a395-c76a-4207-b97d-cf92e10aa6ce

## TODOs

 - [ ] Improve and optimize the scratch percentage calculation
 - [ ] Improve the ContentView usage to prevent adding it multiple times. Currently it's used 4 times: 
    - The first time hidden by the canvas view
    - The second time to be revealed when the scratch percentage is greater than X percent
    - The third as a mask for particles
    - The last one behind the blurview
 - [ ] Start deleting lines only if the user hasn't touched the view for X seconds 
