function [ output_args ] = geometricVerification(sortedIdx, queryVisualWord, imgInvidualVisualWords, queryFrame, frames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:10
        id = sortedIdx(i);
        [matched, idx] = ismember(queryVisualWord, imgInvidualVisualWords{id});
        matches = [find(matched); idx(matched)];
        minInliers = 6;
        tolerance1 = 20;
        tolerance2 = 15;
        loopNum = 4;
        tolerance = tolerance1;
        numMatches = length(matches);
        inliers = cell(1, numMatches);
        H = cell(1, numMatches);
        
        needInliers = 0.7 * numMatches;
        
        point1 = double(queryFrame(1:2, matches(1, :)));
        point2 = double(frames{id}(1:2, matches(2, :)));
        point1_ = point1;
        point2_ = point2;
        point1_(end + 1, :) = 1;
        point2_(end + 1, :) = 1;
        for j = 1 : numMatches
            for k = 1 : 4
                if k == 1
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
                    point1H = H21(1:2, :) * point1_;
                else
                    H21 = point2(:, inliers{i}) / point1_(:, inliers{i});
                    point1H = H21(1:2, :) * point1_;
                    H21(3, :) = [0 0 1];
                    tolerance = tolerance2;
                end;
                dist = sum((point1H - point2).^2);
                inliers{i} = find(dist < tolerance^2);
                H{i} = H21;
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
    end

end

