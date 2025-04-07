
import probabilistic.Choice;

/*
 * Making a fair coin flip from a biased coin.
 * 
 * @author Yash Dhamija
 */
public class FairBiasedCoin {
	
	/* 
	 * @param a real number between 0 and 1, exclusive of boundaries.
	 * 
	 * @return 0 or 1, both with probability p(1-p).
	 */
	public static int roll(double p) {
		double[] choices = {p, 1-p};
		int x = Choice.make(choices);
		int y = Choice.make(choices);
				
		while((x == 0 && y == 0) || (x == 1 && y == 1)) {
			x = Choice.make(choices);
			y = Choice.make(choices);
		}
		
		if (x == 0  && y == 1)
			return 0;
		else
			return 1;
	}
}
