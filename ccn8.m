
a = imread('tur.jpg');
a = im2bw(a,0.2);
%{
I2 = [0,1,1,0,0,1,1,0,0,1,1,0,0,1,1;
     1,1,1,1,1,1,1,1,0,0,1,1,1,1,0;
     0,0,1,1,1,1,0,0,0,1,1,0,1,0,0;
      0,1,1,1,1,0,0,0,1,1,1,0,0,1,1;
      1,1,1,0,0,1,1,0,0,0,1,1,1,0,0;
      0,1,1,0,0,0,0,0,1,1,0,0,0,1,1;
      0,0,0,0,0,1,1,1,1,0,0,1,1,1,1];
%}
[m,n] = size(a);
%padding
I = zeros(m+2,n+2);
I(2:m+1,2:n+1) = a;
% 1st Pass
A = [];
count = 2;
for i = 2:m+1
    for j = 2:n+1
        if I(i,j) ~= 0
           if (I(i-1,j) == 0)&& (I(i,j-1) ==0) && (I(i-1,j-1)==0) && (I(i-1,j+1) == 0)
               I(i,j) = count;
               count = count+1;
           elseif (I(i-1,j) ~= 0)&& (I(i,j-1) ==0) && (I(i-1,j-1)==0) && (I(i-1,j+1) == 0)
               I(i,j) = I(i-1,j);
           elseif (I(i-1,j) == 0)&& (I(i,j-1) ~=0) && (I(i-1,j-1)==0) && (I(i-1,j+1) == 0)
               I(i,j) = I(i,j-1);
           elseif (I(i-1,j) == 0)&& (I(i,j-1) ==0) && (I(i-1,j-1)~=0) && (I(i-1,j+1) == 0)
               I(i,j) = I(i-1,j-1);   
           elseif (I(i-1,j) == 0)&& (I(i,j-1) ==0) && (I(i-1,j-1)==0) && (I(i-1,j+1) ~= 0)
               I(i,j) = I(i-1,j+1);
           else
               I(i,j) = max([I(i-1,j),I(i,j-1),I(i-1,j-1),I(i-1,j+1)]);
               A = unique([A,sort([I(i-1,j);I(i,j-1);I(i-1,j-1);I(i-1,j+1)])]','rows')';
           end
        end
    end
end

[a,b] = size(A);
I = I(2:m+1,2:n+1);
for j = 1:b
    for i= 1:a
        if A(i,j) == 0
           A(i,j) = max([A(1,j),A(2,j),A(3,j),A(4,j)]);
        end
    end
    A(:,j) = sort([A(1,j) A(2,j) A(3,j) A(4,j)]);
end
A = unique(A','rows')';
[a,b] = size(A);
for i = 1:b
    temp1 = max([A(1,i),A(2,i),A(3,i),A(4,i)]);
    temp2 = min([A(1,i),A(2,i),A(3,i),A(4,i)]);
    for j = 1:a
        for k =1:b
           if (i ~= k) && (A(j,k) == temp1)
               A(j,k) = temp2;
           end
        end
    end
end
% 2nd Pass
A = unique(A','rows')';
[a,b] = size(A);
for i = 1:m
    for j = 1:n
        for k = 1:b
            if (I(i,j) == A(4,k)) 
               I(i,j) = A(1,k);   
            end
        end
    end
end
            
%I5 = label2rgb(I);
imwrite(I5,'out_turcc8.jpg');
figure;
imshow('out_turcc8.jpg'); 
        
        
        


