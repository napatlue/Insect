function [D1,D2,D3,D4,D5,A1,A2,A3,A4,A5] = wav_extract(t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[A1,D1] = dwt(t,'db4');
[A2,D2] = dwt(A1,'db4');
[A3,D3] = dwt(A2,'db4');
[A4,D4] = dwt(A3,'db4');
[A5,D5] = dwt(A4,'db4');

end

