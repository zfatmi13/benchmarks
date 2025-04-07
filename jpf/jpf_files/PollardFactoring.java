import java.util.ArrayList;
import probabilistic.UniformChoice;

import java.lang.Math;
public class PollardFactoring {
	/**
	 * Simple method to obtain a factor of the integer N
	 * @param N
	 * @return a factor of N
	 */
	public static int factor (int N) {
		ArrayList<Integer> pseudoRans = new ArrayList<Integer>();
		int x0 = UniformChoice.make(N);
		pseudoRans.add(x0);
		for (int i=1; i<N; i++) {
			pseudoRans.add(((int)Math.pow(pseudoRans.get(i-1), 2) -1)%N);
			for (int j=0; j<i; j++) {
				int x = pseudoRans.get(i) - pseudoRans.get(j);
				int fac = gcd(x, N);
				if (fac != 1) {
//					if (fac == N ) {
//						System.out.println("N is prime.");
//					}
//					System.out.println(fac);
					return fac;
				}
			}
		}
		return 0;
		
		
	}
	/**
	 * @param a
	 * @param b
	 * @return greatest common denominator of a and b
	 */
	public static int gcd(int a, int b) {
		if (b == 0) {
			return a;
		}
		else {
			return gcd(b, Math.floorMod(a, b));
		}
	}
}
