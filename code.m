% matlab 2019
% raw_COVID---COVID-19 
% raw_Suspected---Suspected
% raw_Healthy:---Healthy Individuals
% three experimenters take the Raman scan for each sample and repeated five times, 
% 5 scans conducted by each experimenter of each serum sample were averaged.
% Among the total 156 Raman spectra of 54 serum samples in the Suspect group, only two Raman spectra were obtained in subjects 16 to 21
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setp 1: Test decision for the null hypothesis that the data in vector x comes from a distribution in the normal family
% Here the x is raw_COVID¡¢raw_Suspected and raw_Healthy, see data.mat file.
load data.mat;
for i = 1:length(raw_COVID)   % e.g. test raw_COVID
    [~,p_covid(i)]=lillietest(COVID(i,:));
end


%step 2:resample raw data and Bartlett test of the null hypothesis that the columns of data vector x come from normal distributions with the same variance
a = raw_Suspected(511:900,randperm(156,fix(156*0.8)));
b = raw_COVID(511:900,randperm(159,fix(159*0.8)));
c = raw_Healthy(511:900,randperm(150,fix(150*0.8))); %choose data with wave number from 1500 to 2100 and 80% resample


var_D = [a';b'];
c_vs = [zeros(fix(156*0.8),1);ones(fix(159*0.8),1)];
for i=1:length(511:900)    
    p_vartest(i) = vartestn(var_D(i,:)',c_vs,'Display','off');
end
% e.g. test raw_COVID vs raw_Suspected
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3:  ANOVA test
vs_Point = find((p_covid>0.05).*(p_Suspected>0.05).*(p_vartest>0.05));

for i=1:length(vs_Point) 
    anova_test_raw_COVID_vs_raw_Suspected(i) = anova1(var_D(vs_Point(i),:),c_vs,'off');
end
% e.g. test raw_COVID vs raw_Suspected
% Repeat step  2 and 3 ten times, get the result for Figure 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%step 4:union three ANOVA test result
 a=sum(anova_test_raw_COVID_vs_raw_Suspected);b=sum(anova_test_raw_COVID_vs_raw_Healthy);c=sum(anova_test_raw_Healthy_vs_raw_Suspected);
 [o1,o2]=find(a>7);
 [p1,p2]=find(b>7);
 [q1,q2]=find(c>7);
 kk=union(o2,p2);
 Features_point=union(kk,q2);
 % Features_point is the feature marks of SVM training
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Step 5: training SVM
 a = raw_Suspected(511:900,randperm(156));
 aa = a(Features_point,:);
 b = raw_CONVID(511:900,randperm(159,fix(159*0.8)));
 bb = b(Features_point,:);
 c = raw_Healthy(511:900,randperm(150,fix(150*0.8)));
 cc = c(Features_point,:);
 
 source_train = [aa(:,1:fix(156*0.8)) bb(:,1:fix(159*0.8))];%e.g.  raw_COVID vs raw_Suspected
 label_train = [zeros(1,length(1:fix(156*0.8))) ones(1,length(1:fix(159*0.8)))];
 test_data =[aa(:,fix(156*0.8)+1:end) bb(:,fix(159*0.8)+1:end)];
 
 
 c = cvpartition(fix(156*0.8)+fix(159*0.8),'KFold',fix((fix(156*0.8)+fix(159*0.8))/10));
 opts = struct('Optimizer','bayesopt','ShowPlots',false,'MaxObjectiveEvaluations',30,'CVPartition',c,...    
    'AcquisitionFunctionName','expected-improvement-plus');
svmmod = fitcsvm(source_train,label_train,'KernelFunction','rbf',...
    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);
Label_predict = predict(svmmod,test_data);
% Repeat step 5 ten times, get result for Table 2





