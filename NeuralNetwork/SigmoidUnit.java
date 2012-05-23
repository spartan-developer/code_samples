package NeuralNetwork;

import static java.lang.Math.*;
import java.util.Vector;

public class SigmoidUnit {
    double weights[];
    double errorTerm;
    double errors[];
    public SigmoidUnit(int nInputs) {
        weights = new double[nInputs+1];
        errors = new double[nInputs+1];
        for (int i = 0; i < weights.length; i++) {
            weights[i] = random()/20 - 0.025;
            errors[i] = 0.0;
        }
        
    }
    
    public double propagate(Vector<Double> inputs) {
        double net = weights[0];
        for (int i = 1; i < weights.length; i++)
            net += weights[i] * inputs.get(i-1);
        return 1 / (1 + pow(E, -net));
    }
}
