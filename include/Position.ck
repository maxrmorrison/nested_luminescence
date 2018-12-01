/* Position class for simple manipulations of cartesian coordinates */
public class Position {
	float x;
	float y;
	float distance;
	float theta;
	float perceivedGain;
	/* Completely overwrite current position via cartesian coords
	   Inverse square law used to calculate a perceived gain level */
	fun void set(float x_, float y_) {
		x_ => x;
		y_ => y;
		Math.hypot(x, y) => distance;
		Math.atan2(y, x) => theta;
		1.0 / Math.pow(distance, 2) => perceivedGain;
	}
	/* Completely overwrite current position via polar coords
	   Inverse square law used to calculate a perceived gain level */
	fun void setPolar(float r_, float theta_) {
		r_ => distance;
		theta_ => theta;
		distance * Math.cos(theta) => x;
		distance * Math.sin(theta) => y;
		1.0 / Math.pow(distance, 2) => perceivedGain;
	}
	/* Pass in values used to incrementally update position
	   Inverse square law used to calculate a perceived gain level */
	fun void update(float x_inc, float y_inc) {
		x_inc +=> x;
		y_inc +=> y;
		Math.hypot(x, y) => distance;
		Math.atan2(y, x) => theta;
		1.0 / Math.pow(distance, 2) => perceivedGain;
	}
}
