import java.util.ArrayList;

import probabilistic.UniformChoice;
public class Queens {
	/**
	 * A randomized implementation of the eight queens problem. Creates such a placement and then returns true
	 * @param n, the size of the nxn board
	 */	
	public static boolean Queens(int k, int [][] board, int n) {
		if (k==n) {
			return true;
		}
		ArrayList<Integer> safeSpots = new ArrayList<Integer>();
		for (int i=0; i<n; i++) {
			if (isSafe(k, i, board, n)) {
				safeSpots.add(i);
			}
		}
		if (safeSpots.size() ==0) {
			return false;
		}		
		int chosenSpot = UniformChoice.make(safeSpots.size());
		int j = safeSpots.get(chosenSpot);
		board[k][j]=1;
		return Queens(k+1, board, n);
	}
	public static boolean isSafe(int k, int i, int [][] board, int n) {
		if (k==0) {
			return true;
		}
		else {
			//check if there is already a queen in that column
			for (int row=0; row<k; row++) {
				if (board[row][i]==1) {
					return false;
				}
			}
			//check if there is already a queen in the left diagonal
			int j=1;
			while(j<=k && j<=i) {
				if (board[k-j][i-j]==1) {
					return false;
				}
				j++;
			}
			//check if there is already a queen in the right diagonal
			j=1;
			while (j<=k && j< (n-i)) {
				if (board[k-j][i+j]==1) {
					return false;
				}
				j++;
			}
			return true;
		}
	}

	
}

