function [inliers] = geometricVerification(frame1, frame2, matched)
%Implement RANSAC algorithm follow steps
% Choose 2 matched points
% compute homography matrix
% apply homography matrix and compute number of inliers
% if number of inliers is enough then homography matrix is found
% if number of inliers is not enough then repeat step with decreased
% tolerance
% if number of loop reached then go to new pair of matched points and
% repeat these step.
    minInliers = 6;
    tolerance1 = 20;
    tolerance2 = 15;
    loopNum = 4;
    tolerance = tolerance1;
    
    numMatched = size(matched, 2);
    inliers = cell(1, numMatched);
    
    needInliers = 0.7 * numMatched;
    
    point1 = double(frame1(1:2, matched(1, :)));
    point2 = double(frame2(1:2, matched(2, :)));
    
    point1_ = point1;
    point2_ = point2;
    point1_(end + 1, :) = 1;
    point2_(end + 1, :) = 1;
    
    for i = 1: numMatched
        for j = 1: loopNum
            if j == 1
                %compute homography matrix
                f1 = frame1(:, matched(1, i));
                f2 = frame2(:, matched(2, i));
                t1 = f1(1:2);
                s1 = f1(3);
                o1 = f1(4);
                t2 = f2(1:2);
                s2 = f2(3);
                o2 = f2(4);
                A1 = [s1*[cos(o1) -sin(o1); sin(o1) cos(o1)], t1; 0 0 1];
                A2 = [s2*[cos(o2) -sin(o2); sin(o2) cos(o2)], t2; 0 0 1];
                H21 = A2 * inv(A1);
                %multiply point1 by homography matrix to get corresponding
                %matrix
                point1H = H21(1:2, :) * point1_;
                tolerance = tolerance1;
            else
                H21 = point2(:, inliers{i}) / point1_(:, inliers{i});
                point1H = H21(1:2, :) * point1_;
                H21(3, :) = [0 0 1];
                tolerance = tolerance2;
            end
            %compute number of inliers by distance between points
            dist = sum((point1H - point2).^2);
            inliers{i} = find(dist < tolerance^2);
            if(size(inliers{i}, 2) < minInliers)
                %too few inliners, break;
                break;
            end
            if(size(inliers{i}, 2) > needInliers)
                %homography matrix found;
                break;
            end
        end;
    end;
    scores = cellfun(@numel, inliers);
    [~, maxIdx] = max(scores);
    if ~isempty(maxIdx)
        inliers = inliers{maxIdx};
    else
        inliers = [];
    end
    
end

