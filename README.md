# HDC_ISOLET_VHDL
Hyperdimensional Computing VHDL implementation for recognizing spoken letters



Running            --------------------

In the Deliverables folder there are 3 Matlab .m files, 5 Matlab Array .mat files, and 1 VHDL .vhd file

To run:

1. Record any testing audio using the HDCRecordAudioFile.m
2. Encode the Audio into Hypervectors using HDCTestEncoding.m
3. Download the Vowels33Trials.mat and import it into HDCTrainingPhase.m
4. Download and import the digitHVsthree.mat and classHVsthree.mat into HDCTrainingPhase.mat
5. Run HDCTrainingPhase.m to compute the Class Hypervectors
6. Take the Class Hypervectors and Test Hypervectors and paste them into the testing.vhd
7. Run testing.vhd to compute the number of correct predictions.
