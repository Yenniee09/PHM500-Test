   raw_XXXX is the raw data of different group

   raw_COVID: COVID-19 (Rows:900 and columns:159);

   raw_Suspected: Suspected (Rows:900 and columns:156);

   raw_Healthy: Healthy Individuals (Rows:900 and columns:150);

   raw_Tube: Raman spectra of Cryopreservation Tubes with normal saline                  (Rows:900 and columns:12); 

   Data description:three experimenters take the Raman scan for each sample          and repeated five times, 5 scans conducted by each experimenter of           each serum sample    were averaged;
        Among the total 156 Raman spectra of 54 serum samples in the Suspect         group,only two Raman spectra were obtained in subjects 16 to 21;

wave_number is the Raman Spectrum shift (Rows:900 and columns:1)

Fig2_1、Fig2_2、Fig2_3、Fig2_4、Fig2_5、Fig2_6 is used to plot Figure 2

Figure 1 ploted by raw_XXXX data and Fig2_1, Fig2_2,Fig2_3 data

data of table2 is table2_data.txt 

See code.m for data processing flow,Open data.mat and Running the code.m need in Matlab environment

The data has two formats: TXT and MAT