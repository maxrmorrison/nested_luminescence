public class Firefly {
	/* Statistics gathered from
		 Cratsley, Christopher K., and Sara M. Lewis. "Female preference
		 for male courtship flashes in Photinus ignitus fireflies."
		 Behavioral Ecology 14.1 (2003): 135-140.
	*/
	77.3 => static float FLASH_DURATION_MEAN;
	12.8 => static float FLASH_DURATION_SD;
	31   => static int   FLASH_DURATION_TRIALS;
	3.4  => static float LANTERN_AREA_MEAN;
	0.7  => static float LANTERN_AREA_SD;
	77   => static int   LANTERN_AREA_TRIALS;

	/***************************Object Constructor***************************/

	/* Location Parameters */
	Position position;
	/* Normally Distributed Mating Preference Parameters */
	Stat.randn(FLASH_DURATION_MEAN,
		       FLASH_DURATION_SD,
		       FLASH_DURATION_TRIALS)::ms => dur flash_duration;
	Stat.randn(LANTERN_AREA_MEAN,
			   LANTERN_AREA_SD,
			   LANTERN_AREA_TRIALS) => float lantern_area;
	/* Signal chain */
	LPF lpf => HPF hpf => JCRev rev => Gain g => Ambisonics ambi;
	g.gain(0.05);
	/* Load samples for sonification of simulation */
	SndBuf flashSound, wingSound, connectSound;
	loadSounds();
	/* All Fireflies flash and emit a sound based on that flash while flying */
	spork ~ movement() @=> Shred@ movementShred;

	/*************************End Object Constructor*************************/

	/* Populates the buffers with pitched samples corresponding
	   to the size of the Firefly's lantern
	   Larger lanterns make lower light and connect sounds */
	fun void loadSounds() {
		Stat.normalValueToPercentileIndex(lantern_area,
									      LANTERN_AREA_MEAN,
									      LANTERN_AREA_SD,
									      LANTERN_AREA_TRIALS) => int index;
		indexToFileSuffix(index) => string fileSuffix;
		loadFlashSound(fileSuffix);
		loadWingSound();
		loadConnectSound(fileSuffix);
	}
	/* Populate the flashSound buffer */
	fun void loadFlashSound(string fileSuffix) {
		me.dir(-1) + "audio/flash_" + fileSuffix + ".wav" => flashSound.read;
		flashSound.pos(flashSound.samples() - 1);
	}
	/* Populate the wingSound buffer */
	fun void loadWingSound() {
		me.dir(-1) + "audio/wing.wav" => wingSound.read;
		wingSound.pos(wingSound.samples() - 1);
	}
	/* Populate the connectSound buffer */
	fun void loadConnectSound(string fileSuffix) {
		me.dir(-1) + "audio/connect_" + fileSuffix + ".wav" => connectSound.read;
		connectSound.pos(connectSound.samples() - 1);
	}
	/* Buzz around and pseudorandomly flash
	   lantern for Firefly's flash duration */
	fun void movement() {
		Math.random2(1500,10000)::ms => now;
		while (true) {
			Math.random2(500,1500)::ms => dur ation;
			spork ~ playWingSound(ation);
			spork ~ playFlashSound();
			ation => now;
		}
	}
	/* Playback of flashSound buffer
	   Gain level is based in inverse square law and
	   calculated in Position.ck */
	fun void playFlashSound() {
		flashSound.pos(0);
		flashSound => lpf;
		flash_duration => now;
		flashSound =< lpf;
	}
	/* Playback of wingSound buffer
	   Chooses a random place in the file to play from so
	   long as there is sufficient number of samples until
	   the end of file
	   Gain level is based in inverse square law and
	   calculated in Position.ck */
	fun void playWingSound(dur ation) {
		(ation / samp) $ int => int samplesToPlay;
		wingSound.samples() - samplesToPlay - 1 => int maxPos;
		wingSound.pos(Math.random2(0, maxPos));
		wingSound => lpf;
		ation => now;
		wingSound =< lpf;
	}
	/* Playback of connectSound buffer
	   Gain level is based in inverse square law and
	   calculated in Position.ck */
	fun void playConnectSound() {
		cherr <= "Playing connect sound\n";
		connectSound.pos(0);
		connectSound => lpf;
		connectSound.length() => now;
		connectSound =< lpf;
	}
	/* Called whenever the firefly is moved in the nest in order
	   to update the perceptual effects of distance via filters,
	   reverberation, and panning */
	fun void effectsUpdate() {
		updateLPF();
		updateHPF();
		updateRev();
		updateDirection();
	}
	/* Handle the high frequency attenuation due to position
	   by first finding the angular position of the firefly
	   (assuming we are facing PI / 2) and linearly attenuating
	   from 20000 to 1500 Hz */
	fun void updateLPF() {
		position.theta => float theta;
		if (theta < -0.5 * Math.PI) 2.0 * Math.PI +=> theta;
		Math.fabs(0.5 * Math.PI - theta) => float HFAtten;
		Std.ftom(1500) => float lowerBound;
		Std.ftom(20000) -  lowerBound => float linearRange;
		Std.mtof(HFAtten / Math.PI * linearRange + lowerBound) => float HFCutoff;
		lpf.freq(HFCutoff);
	}
	/* Handle the low frequency attenuation due to distance from
	   the listener. Linearly attenuates from 30 to 150 Hz between
	   distances of 1 and 5 meters */
	fun void updateHPF() {
		1.0 - (position.distance / 5.0) => float LFAtten;
		Std.ftom(30) => float lowerBound;
		Std.ftom(150) - lowerBound => float linearRange;
		Std.mtof(LFAtten * linearRange + lowerBound) => float LFCutoff;
		hpf.freq(LFCutoff);
	}
	/* Handles the reverberant effects of distance */
	fun void updateRev() {
		0.01 + position.distance / 25.0 => float revMix;
		rev.mix(revMix);
	}
	/* Handles the Ambisonics update to track firefly location */
	fun void updateDirection() {
		ambi.setDirection(position.x / 5.0, position.y / 5.0);
	}
	/* Remove primary movement thread of the Firefly
	   Nest.ck handles the new position of the Firefly
	   Firefly will respawn within 1.5 to 10 seconds */
	fun void reset() {
		movementShred.exit();
		spork ~ movement() @=> movementShred;
	}
	/* Converts an integer index corresponding to the
	   percentile range of the lantern area to the
	   note value used to index the correct .wav file sample */
	fun static string indexToFileSuffix(int index) {
		if (index == 0) return "C3";
		else if (index == 1) return "D3";
		else if (index == 2) return "Eb3";
		else if (index == 3) return "G3";
		else if (index == 4) return "Ab3";
		else if (index == 5) return "C4";
		else if (index == 6) return "D4";
		else if (index == 7) return "Eb4";
		else if (index == 8) return "G4";
		else if (index == 9) return "Ab4";
		else cherr <= "Error in Firefly::indexToFileSuffix:" +
					  "invalid index value of " + index + "\n";
	}
}
