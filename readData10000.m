%function readData
close all
clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load btBusData.noHeader.csv-000.txt_float.mat
% M = importdata('24580750104101219.csv');
% 
% one_patch=M.data;
%%%%%%%%%%%%%%%%%%

NextStop=one_patch(:,1);%NextStop      : float  1076 2090 2301 1312 1041 1408 2315 1109 3141 1151 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LineNr=one_patch(:,2);%LineNr   : float  6 23 600 4 1 5 22 12 311 500 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Longitude=one_patch(:,3);%Longitude     : float  15.7 15.3 15.5 15.6 15.6 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Delay=one_patch(:,4);%Delay   : float  31 254 35 25 66 162 208 47 403 199 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LastReport=one_patch(:,5);%LastReport    : float (epoch seconds, since 1900) 1.51e+09 1.51e+09 1.51e+09 1.51e+09 1.51e+09 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cog=one_patch(:,6);%Cog   : float  345 278 235 173 114 0 0 279 336 51 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
UnitId=one_patch(:,7);%UnitId  : float  101222 101214 101260 100458 101204 100461 101208 101270 101233 101252 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Latitude=one_patch(:,8);%Latitude      : float  56.2 56.2 56.2 56.3 56.2 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TripNr=one_patch(:,9);%TripNr  : float  41 31 20 53 98 42 29 14 27 10 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NextStopTime=one_patch(:,10);% NextStopTime  : float (epoch seconds, since 1900) 1.51e+09 1.51e+09 1.51e+09 1.51e+09 1.51e+09 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LastReportYear=one_patch(:,11);%LastReportYear: float  2017 2017 2017 2017 2017 ...
LastReportMon=one_patch(:,12);%LastReportMon : float  11 11 11 11 11 11 11 11 11 11 ...
LastReportDay=one_patch(:,13);%LastReportDay : float  17 17 17 17 17 17 17 17 17 17 ...

LastReportWDay=one_patch(:,14);%LastReportWDay: float (day of week, 1 ~ 7) 6 6 6 6 6 6 6 6 6 6 ...

LastReportHour=one_patch(:,15);%LastReportHour: float (0 ~ 23) 12 12 12 12 12 12 12 12 12 12 ...
LastReportMin=one_patch(:,16);%LastReportMin : float  24 24 24 24 24 24 24 24 24 24 ...
LastReportSec=one_patch(:,17);%LastReportSec : float  20 19 19 19 20 20 22 22 22 23 ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NextStopYear=one_patch(:,18);%NextStopYear  : float  2017 2017 2017 2017 2017 ...
NextStopMon=one_patch(:,19); %NextStopMon   : float  11 11 11 11 11 11 11 11 11 11 ...
NextStopDay=one_patch(:,20); %NextStopDay   : float  17 17 17 17 17 17 17 17 17 17 ...

NextStopWDay=one_patch(:,21); %NextStopWDay  : float (day of week, 1 ~ 7)  6 6 6 6 6 6 6 6 6 6 ...

NextStopHour=one_patch(:,22); %NextStopHour  : float (0 ~ 23) 12 12 12 12 12 12 12 12 12 12 ...
NextStopMin=one_patch(:,23); %NextStopMin   : float  24 24 30 24 24 24 25 25 24 25 ...
NextStopSec=one_patch(:,24); %NextStopSec   : float  59 31 46 24 58 38 46 37 20 55 ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tp=find(LineNr==6);
% t1=UnitId(tp);
%%%%%%%%%%%%%%%%%%%%%%
%tu=find(UnitId==101222);
tu=find(UnitId==101222 & TripNr==41 & LineNr==6);
%%%%%%%%%%%%%%%%%%%%%5
timeInterval=diff(LastReport(tu));
figure,plot(timeInterval),title('Time interval')
%%%%%%%%%%%%%%%%%%%%%%
InitTime=0;
timeV=zeros(length(timeInterval)+1,1);
timeV(1)=InitTime;
for kk=1:length(timeInterval)
    timeV(kk+1)=timeV(kk)+timeInterval(kk);
end
%%%%%%%%%%%%%%%%%%%%%%%
ns=NextStop(tu);
figure,plot(timeV,ns,'b'),title('X=time, Y=Staion code, showing the time to approach a station')
%%%%%%%%%%%%%%%%%%%%%%
dl=Delay(tu);
figure,plot(timeV,ns,'r'),hold on
plot(timeV,dl+ns,'k'),title('the time delay to approach a station')
%%%%%%%%%%%%%%%%%%%%%
NextSationsList=-100;
for kk=1:length(ns)
   if isempty(find(NextSationsList==ns(kk)))
        NextSationsList=[NextSationsList,ns(kk)];
   end
end
NextSationsList=NextSationsList(2:end);
%%%%%%%%%%%%%%%%%%%
for kk=1:length(NextSationsList)
    timeSeries(kk).station= NextSationsList(kk);
    tp=find(ns==NextSationsList(kk));
    delayV=dl(tp);
    timeSeries(kk).delayV=delayV;
    tV=timeV(tp);
    timeSeries(kk).time=tV;
end
%%%%%%%%%%%%%%%%%%%%
figure,hold on, title('Delay time series for each station approach')
for kk=1:length(NextSationsList)

    plot(timeSeries(kk).time,timeSeries(kk).delayV)
end

%http://130.206.112.153:3501/


 figure,plot(timeSeries(3).time,timeSeries(3).delayV,'*'),hold on
 
length(timeSeries(3).delayV)
numberOfMissingPoints=max(timeSeries(3).delayV)- min(timeSeries(3).delayV)-length(timeSeries(3).delayV);

indexOfCurrentPoints=timeSeries(3).time-min(timeSeries(3).time)+1
figure,plot(indexOfCurrentPoints+203,timeSeries(3).delayV,'r*'),hold on
plot(indexOfCurrentPoints+203,timeSeries(3).delayV,'b')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for this special case
tt=timeSeries(3).time;
yy=timeSeries(3).delayV;

indexOfMissingPoints=[];
pp=1;
for kk=1:length(min(tt):max(tt))
    
    if kk==indexOfCurrentPoints(pp)
        pp=pp+1;
    else
        indexOfMissingPoints=[indexOfMissingPoints,kk];
    end
    
end

%%%%%%%%%%%%%%%%%
recoverY(1:length(min(tt):max(tt)))=0;
recoverY(indexOfCurrentPoints)=yy;
recoverY(indexOfMissingPoints)=NaN;

Y2=fillgaps(recoverY);
%%%%%%%%%%%%
timeIndex=1:length(min(tt):max(tt));
figure,plot(timeIndex,Y2,'g*'), hold on
plot(timeIndex,recoverY,'r*')
plot(timeIndex,Y2,'b')





