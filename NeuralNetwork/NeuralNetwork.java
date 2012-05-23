package NeuralNetwork;

import static java.lang.Math.*;
import java.util.Vector;

public class NeuralNetwork {
    Vector<SigmoidUnit> hiddenLayer = new Vector<SigmoidUnit>();
    Vector<SigmoidUnit> outputLayer = new Vector<SigmoidUnit>();
    Vector<Example> trainingExamples;
    double learningRate;
    int nIn, nHidden, nOut;
    public NeuralNetwork(Vector<Example> training, double n, int in, int hidden, int out) {
        trainingExamples = training;
        learningRate = n;
        nIn = in;
        nHidden = hidden;
        nOut = out;
        for (int i = 0; i < nHidden; i++)
            hiddenLayer.add(new SigmoidUnit(nIn));
        for (int i = 0; i < nOut; i++)
            outputLayer.add(new SigmoidUnit(nHidden));
    }
    
    void train() {
        for (Example example : trainingExamples) {
            Vector<Double> hiddenOutputs = new Vector<Double>();
            for (SigmoidUnit h : hiddenLayer)
                hiddenOutputs.add(h.propagate(example.inputs));
            
            for (int i = 0; i < nOut; i++) {
                double o = outputLayer.get(i).propagate(hiddenOutputs);
                double t = example.targetValues.get(i);
                outputLayer.get(i).errorTerm = o * (1 - o) * (t - o);
            }
            
            for (int i = 0; i < nHidden; i++) {
                double sum = 0.0;
                for (SigmoidUnit k : outputLayer)
                    sum += k.weights[i+1] * k.errorTerm;
                double o = hiddenOutputs.get(i);
                hiddenLayer.get(i).errorTerm = o * (1 - o) * sum;
            }
            
            for (SigmoidUnit k : outputLayer)
                for (int w = 0; w < k.weights.length; w++)
                    k.weights[w] += learningRate * k.errorTerm * (w == 0 ? 1 : hiddenOutputs.get(w-1));
            for (SigmoidUnit h : hiddenLayer)
                for (int w = 0; w < h.weights.length; w++)
                    h.weights[w] += learningRate * h.errorTerm * (w == 0 ? 1 : example.inputs.get(w - 1));
        }
        /*
        for (SigmoidUnit k : outputLayer)
            for (int w = 0; w < k.weights.length; w++) {
                k.weights[w] += learningRate * k.errors[w];
                k.errors[w] = 0.0;
            }
        for (SigmoidUnit h : hiddenLayer)
            for (int w = 0; w < h.weights.length; w++) {
                h.weights[w] += learningRate * h.errors[w];
                h.errors[w] = 0.0;
            }
    */
     }
    
    
    Vector<Double> evaluate(Vector<Double> inputs) {
        Vector<Double> hOut = new Vector<Double>();
        for (SigmoidUnit h : hiddenLayer)
            hOut.add(h.propagate(inputs));
        Vector<Double> output = new Vector<Double>();
        for (SigmoidUnit k : outputLayer)
            output.add(k.propagate(hOut));
        return output;
    }
    Vector<Double> hidden(Vector<Double> inputs) {
        Vector<Double> output = new Vector<Double>();
        for (SigmoidUnit h : hiddenLayer)
            output.add(h.propagate(inputs));
        return output;
    }
    
    double error(Vector<Example> testingSet) {
        double E = 0.0;
        for (Example example : testingSet) {
            Vector<Double> outputs = evaluate(example.inputs);
            for (int o = 0; o < outputs.size(); o++)
                E += pow(example.targetValues.get(o) - outputs.get(o), 2);
        }
        return E/2.0;
    }
    int predict(Vector<Double> inputs) {
        Vector<Double> output = evaluate(inputs);
        int prediction = 0;
        double minDifference = 1000;
        for (int i = 0; i < output.size(); i++) {
            if (abs(output.get(i) - 0.9) < minDifference) {
                minDifference = abs(output.get(i) - 0.9);
                prediction = i+1;
            }
        }
        return prediction;
    }
}
