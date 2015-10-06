a = imread('tur.jpg');
%{
a = [0 1 1 0 0 1 1 0 0 1 1 0 0 1 1;
     1 1 1 1 1 1 1 1 0 0 1 1 1 1 0;
     0 0 1 1 1 1 0 0 0 1 1 1 1 0 0;
     0 1 1 1 1 0 0 0 1 1 1 0 0 1 1;
     1 1 1 0 0 1 1 0 0 0 1 1 1 0 0;
     0 1 1 0 0 0 0 0 1 1 0 0 0 1 1;
     0 0 0 0 0 1 1 1 1 0 0 1 1 1 1];
%}
 %imshow(a);
 %a = im2double(a);
 
 [m,n] = size(a);
 % threshold 
 level = graythresh(a);
 threshold = 0.2;
 a = im2bw(a,threshold);
 %a = (a(:,:,1)>threshold);
 % Padding 
 I = zeros(m+2,n+2,'double');
 I(2:m+1,2:n+1) = a;
 A = [];
% imshow(I);

% 1st Pass.
value = 1;
for i =1:1:m+1
    for j = 1:1:n+1
        if(I(i,j) ==1)
            if(I(i,j-1) == 0 && I(i-1,j) == 0)
                I(i,j) = value;
                value = value+1;
            elseif(I(i,j-1) ~= 0  && I(i-1,j) ~=  0)
                    I(i,j) = max(I(i,j-1),I(i-1,j));
                    if ~(I(i,j-1) == I(i-1,j))
                         A = [A,[I(i,j-1);I(i-1,j)]];
                    end
            elseif(I(i,j-1) ~= 0  || I(i-1,j) ~=  0)
                    I(i,j) = max(I(i,j-1),I(i-1,j));
                
            end
                
        end
    end

end
   % 2nd pass
A = unique(A.','rows').';
[x,y] = size(A);
for i = 1:y
    c1 = min(A(1,i),A(2,i));
    c = max(A(1,i),A(2,i));
    for j =1:y
        if(i ~= j)
            if(A(1,j) == c)
                A(1,j) = c1;
            elseif(A(2,j) == c)
                A(2,j) = c1;
            end
        end
    end
end

[u,v] = size(I);

 for i =1:u
     for j=1:v
         for k=1:y
             if(I(i,j) == max(A(1,k),A(2,k)))
                 I(i,j) = min(A(1,k),A(2,k));
             end
         end
     end
 end
p = label2rgb(I);
imwrite(p,'out_tur_cc4.jpg');