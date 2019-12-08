I = imread('shapes.jpg');

%in case it is not gray scale
if length(size(I)) > 2
    I = rgb2gray(I);
end 

[result, resultwithnonmax]  = HarrisDetect(I);
imshow(resultwithnonmax);

function [result, resultwithnonmax] = HarrisDetect(I)  
    [rows, columns] = size(I);

    m1 = [-1 0 1];
    K = 0.08; %K is between 0.04 - 0.15
    threshold = 100000;
    
    Ix = filter2(m1,I);
    Iy = filter2(transpose(m1),I); 

    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix.*Iy;
        
    Ix2 = imgaussfilt(Ix2,2);
    Iy2 = imgaussfilt(Iy2,2);
    Ixy = imgaussfilt(Ixy,2);
    
    corners = zeros(rows, columns);
       
    for x = 1:rows
        for y = 1:columns
            M = [Ix2(x,y) Ixy(x,y); Ixy(x,y) Iy2(x,y)];
                
            Mc = det(M) - K*power(trace(M),2);
       
            if (Mc > threshold)
                corners(x,y) = Mc;
            end
        end
    end
    
    I_temp = I; 
    
    for i = 3:rows-2
        for j = 3:columns-2
            if corners(i,j) ~= 0           
                I_temp(i-2:i+2, j-2:j+2) = 255;
            end
        end
    end
    
    result = I_temp; 
    
    % now calculate corner point for other scales and put values to old
    % corners var
    
    m2 = [-2 -1 0 1 2];
    m3 = [-3 -2 -1 0 1 2 3];

    % for m2
    Ix = filter2(m2,I);
    Iy = filter2(transpose(m2),I); 

    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix.*Iy;
        
    Ix2 = imgaussfilt(Ix2,2);
    Iy2 = imgaussfilt(Iy2,2);
    Ixy = imgaussfilt(Ixy,2);
    
    for x = 1:rows
        for y = 1:columns
            M = [Ix2(x,y) Ixy(x,y); Ixy(x,y) Iy2(x,y)];
                
            Mc = det(M) - K*power(trace(M),2);
       
            if (Mc > threshold)
                corners(x,y) = Mc;
            end
        end
    end
    
    % for m3
    Ix = filter2(m3,I);
    Iy = filter2(transpose(m3),I); 

    Ix2 = Ix.^2;
    Iy2 = Iy.^2;
    Ixy = Ix.*Iy;
        
    Ix2 = imgaussfilt(Ix2,2);
    Iy2 = imgaussfilt(Iy2,2);
    Ixy = imgaussfilt(Ixy,2);
    
    for x = 1:rows
        for y = 1:columns
            M = [Ix2(x,y) Ixy(x,y); Ixy(x,y) Iy2(x,y)];
                
            Mc = det(M) - K*power(trace(M),2);
       
            if (Mc > threshold)
                corners(x,y) = Mc;
            end
        end
    end
    
    %non max suppression
    for i = 2:rows-1
        for j = 2:columns-1
            if  ~(corners(i,j) > corners(i-1,j-1) && corners(i,j) > corners(i-1,j) && corners(i,j) > corners(i-1,j+1) && corners(i,j) > corners(i,j-1) && corners(i,j) > corners(i,j+1) && corners(i,j) > corners(i+1,j-1) && corners(i,j) > corners(i+1,j) && corners(i,j) > corners(i+1,j+1) && corners(i,j) > 1000*threshold)
                corners(i,j) = 0;
            end
        end
     end
    
    for i = 3:rows-2
        for j = 3:columns-2
            if corners(i,j) ~= 0           
                I(i-2:i+2, j-2:j+2) = 255;
            end
        end
    end
     
    resultwithnonmax = I;
end