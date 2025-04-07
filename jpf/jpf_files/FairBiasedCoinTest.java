import java.util.*;
/*
 * This class rolls a fair coin giving 0 or 1 based on a biased coin that rolls 0 with certin probability p
 * which is specified by the user.
 *
 * @author Yash Dhamija
 */
public class FairBiasedCoinTest {
	
	public static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Usage: \n<int bias; probability for biased coin ranges "
					+ "from 0.1 to 1>");
		}

		boolean isHead = false;
		
		double bias = Double.parseDouble(args[0]);
		
		isHead = FairBiasedCoin.roll(bias) == 0;
	}
}
