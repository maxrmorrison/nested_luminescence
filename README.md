# Nested Luminescence

## Program Note

While iconic to the lightning bug, the luminescence that we associate with male fireflies plays a very different role in the eyes of a female. The bright nighttime flashes are actually a call to the female firefly, but it is ultimately up to the female whether a male is worthy of fathering her offspring. In Christopher K. Cratsley and Sara M. Lewis's "Female preference for male courtship flashes in Photinus ignitus fireflies" [Behavioral Ecology 14.1 (2003): 135-140.], the mating preferences of the female firefly are discussed, revealing the primary mating criteria of this species to be the lantern area and flash duration of the male firefly.

In this composition, data extracted from the above article such as the mean and standard deviation of the lantern area and flash duration are assigned according to a normal distribution to a nest of fireflies. These fireflies are free to move about their nest, while the female fireflies will gravitate towards those they perceive to be the most desirable.

While listening, notice not only the sonic movement of the fireflies--which is communicated via changes in reverb, filtering, and position in the ambisonic image--but also the average pitch of the sound used to signify a matching of fireflies. Given that fireflies with larger lantern areas are assigned a lower pitch for both their flash and mating sounds, what can you conclude about the female preference for lantern areas in males?

The sounds chosen for sonification include a more literal wing sound for ease of position tracking of each firefly, a mellow sound with an envelope similar to that of a light quickly flashing on and off and a duration that is normally distributed according to the flash duration data, and a longer, more dramatic sound signifying the mating of a male and female firefly.

## Ambisonics

Ambisonics is an audio spatialization method used to project sounds within a 2D or 3D space. The process requires encoding the source audio alongside its position information and decoding that audio based upon the calibrated speaker setup. The ambisonics used in this piece is as simple as it gets-- a 4-speaker planar setup with no room correction, phase correction, or any advanced DSP techniques. To calibrate this composition to a speaker array, open the Ambisonics.ck file in the ./include directory, enter the number of speakers in your planar array that you wish to use, and enter the azimuth values of each speaker in the SPEAKER_AZIMUTH array such that ChucK's first digital output corresponds to SPEAKER_AZIMUTH[0], second to SPEAKER_AZIMUTH[1], etc. ChucK's audio preferences must be setup to allow for a number of digital outputs that is equal or greater to the specified number of speakers.
