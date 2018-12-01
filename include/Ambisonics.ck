/* Chubgraph for basic planar Ambisonics encoding/decoding.
   Must be calibrated to the quantity and azimuthal locations
   of the planar speaker setup. Location updates made through
   the setDirection function.
*/
public class Ambisonics extends Chubgraph {
	4 => static int NUM_SPEAKERS;
	float SPEAKER_AZIMUTH[NUM_SPEAKERS];
	
	/* User-specific speaker azimuth levels */

	/* Ideal 4-Corner Planar */
	//1.0 * Math.PI / 4.0 => SPEAKER_AZIMUTH[0];
	//3.0 * Math.PI / 4.0 => SPEAKER_AZIMUTH[1];
	//5.0 * Math.PI / 4.0 => SPEAKER_AZIMUTH[2];
	//7.0 * Math.PI / 4.0 => SPEAKER_AZIMUTH[3];
	/* End Ideal 4-Corner Planar */
    
    /* Davis Technology Studio Corner Speakers */
    /*             April 25th 2016             */
    0.8632 => SPEAKER_AZIMUTH[0];
	2.2784 => SPEAKER_AZIMUTH[1];
    4.0048 => SPEAKER_AZIMUTH[2];
    5.4200 => SPEAKER_AZIMUTH[3];
   /* End Davis Technology Studio Corner Speakers */

	Gain W_Encode;
	Gain X_Encode;
	Gain Y_Encode;
	
	Gain W_Decode[NUM_SPEAKERS];
	Gain X_Decode[NUM_SPEAKERS];
	Gain Y_Decode[NUM_SPEAKERS];

	inlet => W_Encode;
	inlet => X_Encode;
	inlet => Y_Encode;

	/* Set decode parameters for NUM_SPEAKERS planar speakers
	   Signal multiplication carried out via Gain UGens */
	for (int i; i < NUM_SPEAKERS; ++i) {
		W_Encode => W_Decode[i] => dac.chan(i);
		X_Encode => X_Decode[i] => W_Decode[i];
		Y_Encode => Y_Decode[i] => W_Decode[i];
		/* Pn = (1/N) * (W + 2Xcos(phi) + 2Ysin(phi)) */
		2.0 * Math.cos(SPEAKER_AZIMUTH[i]) => X_Decode[i].gain;
		2.0 * Math.sin(SPEAKER_AZIMUTH[i]) => Y_Decode[i].gain;
		1.0 / NUM_SPEAKERS => W_Decode[i].gain;
	}
	/* Update the Ambisonic direction vector
	   Assumes X_, Y_ are within the unit circle */
	fun void setDirection(float X_, float Y_) {
		X_ => X_Encode.gain;
		Y_ => Y_Encode.gain;
		/* Scale loudness so moving towards the center of the
		   circle does not attenuate volume */
		1.0 - 0.293 * (X_*X_ + Y_*Y_) => W_Encode.gain;
	}
}
