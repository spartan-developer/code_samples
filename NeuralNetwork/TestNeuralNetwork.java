package NeuralNetwork;

import java.util.Vector;
import org.jfree.chart.*;
import org.jfree.chart.plot.*;
import org.jfree.data.xy.*;
import javax.swing.*;

public class TestNeuralNetwork {
    public static void main(String[] args) {
        DataFile dataFile = new DataFile("wine");
        dataFile.normalize();
        Vector<Example> myExamples = dataFile.get_examples();
        java.util.Collections.shuffle(myExamples);
        int cutoff = myExamples.size() /2;
        Vector<Example> trainingSet = new Vector<Example>(myExamples.subList(0, cutoff));
        Vector<Example> testingSet = new Vector<Example>(myExamples.subList(cutoff+1, myExamples.size()-1));
        NeuralNetwork n = new NeuralNetwork(trainingSet, 0.2f, 13, 2, 3);
        
        
        XYSeries trainingError = new XYSeries("Training Set Error");
        XYSeries testError = new XYSeries("Test Set Error");
        for (int i = 1; i < 2000; i++) {
            n.train();
            
                trainingError.add(i, n.error(trainingSet));
                testError.add(i, n.error(testingSet));
            
        }
        
        XYSeriesCollection collection = new XYSeriesCollection();
        collection.addSeries(trainingError);
        collection.addSeries(testError);
        JFreeChart myChart = ChartFactory.createXYLineChart("Neural Network Performance Over \"Wine.dat\"", "iterations", "weights", collection,
                PlotOrientation.VERTICAL, true, false, false);
        ChartPanel chartPanel = new ChartPanel(myChart);
        JFrame myFrame = new JFrame();
        myFrame.add(chartPanel);
        myFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        myFrame.pack();
        myFrame.setVisible(true);
    }
}