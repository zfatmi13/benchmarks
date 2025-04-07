
import java.util.ArrayList;

import probabilistic.Choice;

public class SetIsolation {
	
	/**
	 * Takes two disjoint subsets of size n of a universe U, randomly selects a sample R from U where each element in U
	 * independently has probability p=1/n of being chosen. R is a "good sample" if it is disjoint from S but not 
	 * disjoint from T
	 * @param trials, number of trials
	 * @param N size of the universe, U
	 * @param S, one subset of the universe, disjoint from T
	 * @param T, another  subset of the universe, disjoint from S
	 * @return whether or not R is a "good sample"
	 */
	public static boolean check(int trials, int N, int [] S, int [] T ) {
		if (S.length != T.length ) {
			throw new IllegalArgumentException("S and T must be of same cardinality.");
			
		}
		int n = S.length;
		for (int k=0; k<trials; k++) {
			ArrayList <Integer> R = new ArrayList<Integer>();
			for (int i=0; i<N; i++) {
				//for each element in the universe, add it to R with probability 1/n
				// x is a real number exists in [0, 1) with precision of 4 decimal points
//				double[] p = {1.0/n, (n-1.0)/n};
//				System.out.println("Value n-1.0/n: " + (n-1.0)/n);
				int choice = Choice.make(new double[]{1.0/n, (n-1.0)/n});
				if (choice  == 0)
					R.add(i);
			}
			boolean disjoint=true;
			//check if R and S are disjoint
			for (int i=0; i<R.size(); i++) {
				for (int j=0; j<n; j++) {
					if (R.get(i) == S[j]) {
						disjoint = false;
					}
				}
			}
			if (disjoint) {
				for (int i=0; i<R.size(); i++) {
					for (int j=0; j<n; j++) {
						if (R.get(i) == T[j]) {
							return true;
						}
					}
				}
			}
		}
		return false;
		
	}
	
	public static void main (String args[]) {
		int [] S = {1, 4};
		int [] T = {6, 7};
		
		check(5, 11, S, T);
	}

}
