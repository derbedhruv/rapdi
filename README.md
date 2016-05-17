# Pupil-Tracking
## Author: Dhruv Joshi

We use a MATLAB gui interface and preview functionality to get simultaneous streams from two USB cameras over a single USB interface. An arduino is used to light LEDs for illumination of the eye and stimulation of the pupil.

TODO: Pupil segmentation and realtime overlay.

# Dependencies:
* Arduino drivers - make sure you have drivers for Arduino Micro. This can be easily done by simply installing the latest Arduino IDE.
* You need to install the 'winvideo' adaptor for the Image Acquisition toolbox to be able to acquire video from the cameras. This may be done by typing `supportPackageInstaller` at the MATLAB prompt. Choose OS Generic Video Interface, and install.