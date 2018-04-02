clear
clc
faceDetector = vision.CascadeObjectDetector();
v = vision.VideoFileReader('Pulse-71.avi');
vi = VideoReader('Pulse-71.avi');
videoFrame      = step(v);
bbox            = step(faceDetector, videoFrame);



numFrames = 1;
twarz = {};
while ~isDone(v)
  step(v);
  video = read(vi,numFrames);
  CzerwonyOdcien = video(:,:,3);
  disp(numFrames)
  videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');
  if(numFrames >=900)
      if(numFrames == 1200)
          imshow(CzerwonyOdcien);
      end
  twarz{numFrames-899} = CzerwonyOdcien(bbox(2):(bbox(2)+bbox(4)),bbox(1):(bbox(1)+bbox(3)));
  tablica(numFrames-899) = sum(sum(twarz{numFrames-899})) / (size(twarz{numFrames-899}, 1) * size(twarz{numFrames-899}, 2));
  end
  numFrames = numFrames + 1;
 
    
end

Puls_L = 40;
Puls_H = 240;
[b, a] = butter(2, [((60 / 60) / 30 * 2), ((240 / 60) / 30 * 2)]);
sygnal_filtrowany = filter(b, a, tablica);
czas_stabilizacji_filtru = 3; % w sekundach
sygnal_filtrowany = sygnal_filtrowany((30 * czas_stabilizacji_filtru + 1):size(sygnal_filtrowany, 2));
fftMagnitudeTwarz = abs(fft(sygnal_filtrowany));

freq_dimensionTwarz = 60*((1:round(length(sygnal_filtrowany)))-1)*(vi.FrameRate/length(sygnal_filtrowany));

subplot(2,1,1);
plot(900:vi.NumberOfFrames-1, tablica);
grid on
axis([900,4094,-inf,inf])
xlabel('samples(n)')
ylabel('|Y(n)|')
title('Original Signal')


 
subplot(2,1,2);
plot(freq_dimensionTwarz, fftMagnitudeTwarz);
grid on
axis([0,150,-inf,inf])
xlabel('Frequency [Hz]')
ylabel('|Y(f)|')
title('FFT of filtered signal')


