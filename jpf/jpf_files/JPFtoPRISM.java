
import java.util.HashMap;
import java.util.Map.Entry;
import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.File;
import java.io.PrintWriter;

/**
 * Given a text file containing a DTMC in the output format of jpf-label, this
 * app generates the DTMC in the format given by PRISM.
 * 
 * @author Zainab Fatmi
 */
public class JPFtoPRISM {

	/**
	 * Transforms a DTMC, represented in a transition file and a label file, from
	 * jpf-probabilistic and jpf-label format respectively, to PRISM format.
	 * 
	 * @pre. if the model contains the label "init", the initial states should be
	 * labelled by it.
	 * 
	 * @param args[0] the name of the text files which contain the model in the
	 *                output format of jpf-label.
	 * @param args[1] the name of the text files that contain the model in the
	 *                format given by PRISM.
	 * @param args[2] the precision of the probabilities (optional, default is 5).
	 * @throws IncorrectFileFormatException if a label contains whitespace or any
	 *                                      character besides letters, digits and
	 *                                      the underscore character, or if a label
	 *                                      begins with a digit or is a reserved
	 *                                      keyword in PRISM.
	 */
	public static void main(String[] args) throws IncorrectFileFormatException {
		if (args.length != 2 && args.length != 3) {
			System.out.println(
					"Usage: java label.JPFtoPRISM <file name of JPF model> <file name of PRISM model> <precision (optional)>");
		} else {
			try {
				final int precision;
				if (args.length == 3) {
					precision = Integer.parseInt(args[2]);
				} else {
					precision = 5; // default
				}
				final String modelJPF = args[0];
				final String modelPRISM = args[1];
				final double epsilon = Math.pow(10.0, -precision) / 2.0; // used to determine whether to add a sink
				boolean addSink = false; // true if the model needs to be completed

				// read transition file:
				Scanner input = new Scanner(new File(modelJPF + ".tra"));
				int states = input.nextInt();
				int transitions = input.nextInt(); // original number of transitions

				State[] stateArray = new State[states];
				for (int i = 0; i < states; i++) {
					stateArray[i] = new State();
				}

				// increase the ID of each state by 1 and collect transitions
				for (int i = 0; i < transitions; i++) {
					int source = input.nextInt() + 1;
					int target = input.nextInt() + 1;
					double probability = input.nextDouble();
					stateArray[source].add(target, probability);
				}
				input.close();

				// build the new transition file:
				StringBuilder output = new StringBuilder();
				transitions = 0; // current number of transitions

				for (int s = 0; s < states; s++) {
					for (Entry<Integer, Double> t : stateArray[s].transitions.entrySet()) {
						output.append(String.format("%d %d %." + precision + "f%n", s, t.getKey(), t.getValue()));
						transitions++;
					}
					// add the transitions to the sink state if required
					double leftOver = 1.0 - stateArray[s].sum;
					if (Math.abs(leftOver) >= epsilon) {
						output.append(String.format("%d %d %." + precision + "f%n", s, states, leftOver));
						transitions++;
						addSink = true;
					}
				}
				if (addSink) {
					output.append(String.format("%d %d %." + precision + "f%n", states, states, 1.0));
					transitions++;
					states++;
				}

				// write to the new transition file
				PrintWriter writer = new PrintWriter(modelPRISM + ".tra");
				writer.println(states + " " + transitions);
				writer.print(output);
				writer.close();

				// read the label file
				input = new Scanner(new File(modelJPF + ".lab"));
				output = new StringBuilder();

				// check if the preconditions for the labels hold
				String labelNames = input.nextLine().trim();
				final String[] keywords = { "A", "bool", "clock", "const", "ctmc", "C", "double", "dtmc", "E",
						"endinit", "endinvariant", "endmodule", "endrewards", "endsystem", "false", "formula", "filter",
						"func", "F", "global", "G", "invariant", "I", "int", "label", "max", "mdp", "min", "module",
						"X", "nondeterministic", "Pmax", "Pmin", "P", "probabilistic", "prob", "pta", "rate", "rewards",
						"Rmax", "Rmin", "R", "S", "stochastic", "system", "true", "U", "W" };
				for (String keyword : keywords) {
					if (labelNames.contains("\"" + keyword + "\"")) {
						input.close();
						throw new IncorrectFileFormatException(
								"Labels cannot be reserved keywords in PRISM, such as \"" + keyword + "\".");
					}
				}
				final String[] labels = labelNames.split("\\s");
				for (String label : labels) {
					if (!label.matches("[0-9]+=\"[A-Za-z_][A-Za-z0-9_]*\"")) {
						input.close();
						throw new IncorrectFileFormatException("Labels can only be made of letters, digits and the "
								+ "underscore character, but must not begin with a digit or contain whitespace.");
					}
				}
				int numberOfLabels = labels.length;

				// add the init label if it doesn't exist
				final String initLabel = "=\"init\"";
				if (labelNames.contains(initLabel)) {
					System.out.println("Warning: Ensure that only all initial states are labelled with \"init\".");
				} else {
					labelNames += " " + numberOfLabels + initLabel;
					if (input.hasNextLine()) {
						String[] labelLine = input.nextLine().split(":");
						int state = Integer.parseInt(labelLine[0]) + 1;
						if (state == 0) { // the initial state has other labels
							output.append(state + ":" + labelLine[1] + " " + numberOfLabels + "\n");
						} else {
							output.append("0: " + numberOfLabels + "\n");
							output.append(state + ":" + labelLine[1] + "\n");
						}
					} else {
						output.append("0: " + numberOfLabels + "\n");
					}
					numberOfLabels++;
				}

				// increase the ID of each state by 1
				String[] labelLine;
				while (input.hasNextLine()) {
					labelLine = input.nextLine().split(":");
					output.append((Integer.parseInt(labelLine[0]) + 1) + ":" + labelLine[1] + "\n");
				}
				input.close();

				// add the sink state if required
				if (addSink) {
					labelNames += " " + numberOfLabels + "=\"sink\"";
					output.append((states - 1) + ": " + numberOfLabels + "\n");
				}

				// write to the new label file
				writer = new PrintWriter(modelPRISM + ".lab");
				writer.println(labelNames);
				writer.print(output);
				writer.close();
			} catch (FileNotFoundException e) {
				System.out.println("File could not be read or written.");
				e.printStackTrace();
			}
		}
	}

	/**
	 * Class to store information about each state's outgoing transitions.
	 */
	private static class State {
		private double sum; // sum of the probabilities of outgoing transitions
		private HashMap<Integer, Double> transitions; // ID of the target state and probability of the transition

		private State() {
			this.sum = 0;
			this.transitions = new HashMap<Integer, Double>();
		}

		/**
		 * Add an outgoing transition to this state.
		 * 
		 * @param target      the target state ID
		 * @param probability the probability associated with the transition
		 */
		private void add(int target, double probability) {
			// if a transition to the target state already exists, add the probabilities
			this.transitions.merge(target, probability, (sum, p) -> Double.sum(sum, p));
			this.sum += probability;
		}
	}
}
